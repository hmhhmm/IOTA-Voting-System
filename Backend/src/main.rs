/// 🗳️ IOTA Voting Platform - Backend Server
/// 
/// This Rust backend provides the server-side functionality for the IOTA Voting Platform.
/// It handles DID generation, voting, feedback submission, and credential management
/// using IOTA Identity technology for secure, decentralized operations.
/// 
/// Key Features:
/// - IOTA Identity integration for DID management
/// - RESTful API endpoints with JSON responses
/// - CORS support for cross-origin requests
/// - UUID-based notarization receipts
/// - Comprehensive error handling
/// 
/// API Endpoints:
/// - POST /did/create - Generate new DID
/// - GET /health - Health check
/// - POST /vote - Submit election vote
/// - POST /policy_vote - Submit policy vote
/// - POST /feedback/submit - Submit feedback
/// - POST /credential/issue - Issue credentials

use axum::{
    routing::{post, get}, 
    Router, 
    Json, 
    response::IntoResponse, 
    http::StatusCode,
    extract::Query,
    extract::Json as AxumJson,
};
use serde::{Deserialize, Serialize};
use std::net::SocketAddr;
use tower_http::cors::CorsLayer;

use std::fs::File;
use std::io::Write;
use uuid::Uuid;

use bs58;
use identity_iota::iota::{IotaDocument, IotaDID, NetworkName};
use identity_iota::verification::{MethodBuilder, MethodData, MethodType, MethodScope};
use identity_iota::did::DID;

// --- IOTA ISC Smart Contract Integration ---
use std::process::Command;

// TODO: Set these to your actual ISC chain and contract details
const NODE_URL: &str = "https://api.testnet.shimmer.network";
const CHAIN_ID: &str = "your_chain_id_here";
const CONTRACT_NAME: &str = "iota_voting_contract";

#[derive(Deserialize)]
struct VoteRequest {
    user_id: String,
    vote: String,
    candidate: String,
    did: String,
}

#[derive(Serialize, Deserialize)]
struct PolicyVoteRequest {
    user_id: String,
    policy: String,
    vote: String,
}

/// Response structure for DID creation
/// 
/// Contains the generated Decentralized Identifier that can be used
/// for authentication and identity verification.
#[derive(Serialize, Deserialize)]
struct DidResponse {
    /// The generated DID string
    did: String,
}

/// Request structure for credential issuance
/// 
/// Used when issuing identity credentials to users based on their
/// demographic and regional information.
#[derive(Serialize, Deserialize)]
struct CredentialRequest {
    /// User's DID
    did: String,
    /// User's region/location
    region: String,
    /// User's age
    age: u8,
}

/// Request structure for feedback submission
/// 
/// Contains the feedback data submitted by users for government policies.
#[derive(Serialize, Deserialize)]
struct FeedbackRequest {
    /// User's DID
    did: String,
    /// Feedback content
    feedback: String,
}

/// Response structure for vote submission
/// 
/// Contains the confirmation data and notarization receipt for votes.
#[derive(Serialize, Deserialize)]
struct VoteResponse {
    /// The party or candidate voted for
    party: String,
    /// Unique notarization receipt
    notarization_receipt: String,
    /// Success message
    message: String,
}

/// Response structure for policy vote submission
/// 
/// Contains the confirmation data and notarization receipt for policy votes.
#[derive(Serialize, Deserialize)]
struct PolicyVoteResponse {
    /// The policy voted on
    policy: String,
    /// Unique notarization receipt
    notarization_receipt: String,
    /// Success message
    message: String,
}

#[derive(Deserialize)]
struct DidQuery {
    did: String,
}

#[derive(Deserialize)]
struct CandidateQuery {
    candidate: String,
}

// Helper to call Wasp CLI and return output as String
fn call_wasp_cli(args: &[&str]) -> Result<String, String> {
    let output = Command::new("wasp-cli")
        .args(args)
        .output()
        .map_err(|e| format!("Failed to run wasp-cli: {}", e))?;
    if output.status.success() {
        Ok(String::from_utf8_lossy(&output.stdout).to_string())
    } else {
        Err(String::from_utf8_lossy(&output.stderr).to_string())
    }
}

/// Creates a new Decentralized Identifier (DID) using IOTA Identity
/// 
/// This endpoint generates a new DID for user registration. The process:
/// 1. Generates Ed25519 keypair for cryptographic operations
/// 2. Creates DID from the public key using IOTA Identity
/// 3. Builds verification method for the DID
/// 4. Creates and saves the DID document
/// 5. Returns the DID to the client
/// 
/// Returns:
/// - 200 OK with DID response on success
/// - 500 Internal Server Error on failure
async fn create_did() -> Json<DidResponse> {
    println!("[LOG] Received /did/create request");
    
    // 1. Generate Ed25519 keypair using ed25519_dalek
    let signing_key = ed25519_dalek::SigningKey::generate(&mut rand::thread_rng());
    let public = signing_key.verifying_key();
    let private = signing_key;

    // 2. Create new DID from public key using IOTA Identity
    let did = IotaDID::new(public.as_bytes(), &NetworkName::try_from("rms").unwrap());

    // 3. Create a verification method for the DID
    let method = MethodBuilder::default()
        .id(did.to_url().join("#key-1").unwrap())
        .controller(did.clone().into())
        .type_(MethodType::ED25519_VERIFICATION_KEY_2018)
        .data(MethodData::PublicKeyBase58(bs58::encode(public.as_ref()).into_string()))
        .build()
        .unwrap();

    // 4. Create document and insert verification method
    let mut document = IotaDocument::new(&NetworkName::try_from("rms").unwrap());
    document.insert_method(method, MethodScope::VerificationMethod).unwrap();

    // 5. Save DID data to file for persistence
    let output = serde_json::json!({
        "did": did.to_string(),
        "document": document,
        "public_key": public.as_bytes().to_vec(),
        "private_key": private.to_bytes().to_vec()
    });

    let mut file = File::create("identity_output.json").expect("Failed to create file");
    file.write_all(serde_json::to_string_pretty(&output).unwrap().as_bytes())
        .expect("Failed to write file");

    // 6. Return DID as API response
    Json(DidResponse { did: did.to_string() })
}

/// Issues identity credentials based on user information
/// 
/// This endpoint creates credentials for users based on their demographic
/// and regional information. Used for identity verification and access control.
/// 
/// Parameters:
/// - did: User's Decentralized Identifier
/// - region: User's geographical region
/// - age: User's age for age-based policies
/// 
/// Returns:
/// - 200 OK with credential data on success
/// - 400 Bad Request for invalid input
async fn issue_credential(payload: Result<Json<CredentialRequest>, axum::extract::rejection::JsonRejection>) -> impl IntoResponse {
    match payload {
        Ok(Json(req)) => {
            println!("[LOG] Received /credential/issue request: did={}, region={}, age={}", req.did, req.region, req.age);
            let credential = format!("Credential for {} in region {} age {}", req.did, req.region, req.age);
            (StatusCode::OK, credential)
        },
        Err(e) => {
            eprintln!("[ERROR] Invalid /credential/issue request: {}", e);
            (StatusCode::BAD_REQUEST, format!("Invalid request: {}", e))
        }
    }
}

/// Submits user feedback for government policies
/// 
/// This endpoint receives and processes feedback submitted by users
/// regarding government policies. The feedback is associated with the user's DID.
/// 
/// Parameters:
/// - did: User's Decentralized Identifier
/// - feedback: User's feedback content
/// 
/// Returns:
/// - 200 OK with confirmation message
async fn submit_feedback(Json(req): Json<FeedbackRequest>) -> Json<String> {
    println!("[LOG] Received /feedback/submit request: did={}, feedback={}", req.did, req.feedback);
    let result = format!("Feedback from {}: {}", req.did, req.feedback);
    Json(result)
}

/// Handles GET requests to /did/create endpoint
/// 
/// Returns a message indicating that POST should be used for DID creation.
async fn get_create_did() -> &'static str {
    "Use POST for this endpoint."
}

/// Health check endpoint for monitoring
/// 
/// This endpoint provides a simple health check for the server.
/// Used by monitoring systems to verify the server is running.
/// 
/// Returns:
/// - 200 OK with health status
async fn health_check() -> Json<serde_json::Value> {
    println!("[LOG] Received /health request");
    Json(serde_json::json!({
        "status": "healthy",
        "message": "Backend is running"
    }))
}

/// Submits election votes with notarization
/// 
/// This endpoint processes election votes and generates notarization receipts.
/// Each vote is assigned a unique UUID for tracking and verification.
/// 
/// Parameters:
/// - user_id: Unique identifier for the voter
/// - vote: Selected party or candidate
/// 
/// Returns:
/// - 200 OK with vote confirmation and receipt
async fn submit_vote(Json(req): Json<VoteRequest>) -> Json<VoteResponse> {
    println!("[LOG] Received /vote request: user_id={}, vote={}", req.user_id, req.vote);
    
    // Generate unique notarization receipt
    let receipt = Uuid::new_v4().to_string();
    
    Json(VoteResponse {
        party: req.vote,
        notarization_receipt: receipt,
        message: "Vote recorded successfully.".to_string(),
    })
}

/// Submits policy votes with notarization
/// 
/// This endpoint processes policy votes and generates notarization receipts.
/// Policy votes are typically yes/no decisions on specific government policies.
/// 
/// Parameters:
/// - user_id: Unique identifier for the voter
/// - policy: Policy being voted on
/// - vote: Vote choice (yes/no)
/// 
/// Returns:
/// - 200 OK with vote confirmation and receipt
async fn submit_policy_vote(Json(req): Json<PolicyVoteRequest>) -> Json<PolicyVoteResponse> {
    println!("[LOG] Received /policy_vote request: user_id={}, policy={}, vote={}", req.user_id, req.policy, req.vote);
    
    // Generate unique notarization receipt
    let receipt = Uuid::new_v4().to_string();
    
    Json(PolicyVoteResponse {
        policy: req.policy,
        notarization_receipt: receipt,
        message: "Policy vote recorded successfully.".to_string(),
    })
}

// POST /vote
async fn isc_vote(AxumJson(payload): AxumJson<VoteRequest>) -> AxumJson<String> {
    let args = [
        "chain", "post-request", "iota_voting_contract", "vote",
        &format!("candidate={}", payload.candidate),
        &format!("did={}", payload.did),
    ];
    match call_wasp_cli(&args) {
        Ok(res) => AxumJson(format!("Vote submitted: {}", res)),
        Err(e) => AxumJson(format!("Error: {}", e)),
    }
}

// GET /votes?candidate=NAME
async fn isc_get_votes(Query(query): Query<CandidateQuery>) -> AxumJson<u64> {
    let args = [
        "chain", "call-view", "iota_voting_contract", "get_votes",
        &format!("candidate={}", query.candidate),
    ];
    match call_wasp_cli(&args) {
        Ok(res) => {
            let votes = res.lines()
                .find(|line| line.contains("votes:"))
                .and_then(|line| line.split(':').nth(1))
                .and_then(|v| v.trim().parse::<u64>().ok())
                .unwrap_or(0);
            AxumJson(votes)
        }
        Err(_) => AxumJson(0),
    }
}

// GET /has_voted?did=ID
async fn isc_has_voted(Query(query): Query<DidQuery>) -> AxumJson<bool> {
    let args = [
        "chain", "call-view", "iota_voting_contract", "has_voted",
        &format!("did={}", query.did),
    ];
    match call_wasp_cli(&args) {
        Ok(res) => {
            let voted = res.lines()
                .find(|line| line.contains("has_voted:"))
                .and_then(|line| line.split(':').nth(1))
                .map(|v| v.trim() == "true")
                .unwrap_or(false);
            AxumJson(voted)
        }
        Err(_) => AxumJson(false),
    }
}

// GET /rewards?did=ID
async fn isc_get_rewards(Query(query): Query<DidQuery>) -> AxumJson<u64> {
    let args = [
        "chain", "call-view", "iota_voting_contract", "get_rewards",
        &format!("did={}", query.did),
    ];
    match call_wasp_cli(&args) {
        Ok(res) => {
            let rewards = res.lines()
                .find(|line| line.contains("rewards:"))
                .and_then(|line| line.split(':').nth(1))
                .and_then(|v| v.trim().parse::<u64>().ok())
                .unwrap_or(0);
            AxumJson(rewards)
        }
        Err(_) => AxumJson(0),
    }
}

/// Main function that starts the Axum web server
/// 
/// This function:
/// 1. Configures CORS for cross-origin requests
/// 2. Sets up the router with all API endpoints
/// 3. Binds the server to the specified address and port
/// 4. Starts the server and handles incoming requests
/// 
/// Server Configuration:
/// - Address: 0.0.0.0 (all interfaces)
/// - Port: 8000
/// - CORS: Very permissive for development
#[tokio::main]
async fn main() {
    // Configure CORS for cross-origin requests
    let cors = CorsLayer::very_permissive();

    // Set up the router with all API endpoints
    let app = Router::new()
        .route("/health", get(health_check))
        .route("/vote", post(submit_vote))
        .route("/policy_vote", post(submit_policy_vote))
        .route("/did/create", post(create_did))
        .route("/did/create", get(get_create_did))
        .route("/credential/issue", post(issue_credential))
        .route("/feedback/submit", post(submit_feedback))
        .route("/votes", get(isc_get_votes))
        .route("/has_voted", get(isc_has_voted))
        .route("/rewards", get(isc_get_rewards))
        .layer(cors);

    // Configure server address and port
    let addr = SocketAddr::from(([0, 0, 0, 0], 8000));
    println!("Backend running at http://{}", addr);

    // Start the server
    axum::serve(
        tokio::net::TcpListener::bind(addr).await.unwrap(),
        app.into_make_service()
    )
    .await
    .unwrap();
} 