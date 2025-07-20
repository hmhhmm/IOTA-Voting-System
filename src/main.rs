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