use wasmlib::*;

// State keys
const KEY_VOTES: &str = "votes";
const KEY_VOTED: &str = "voted";
const KEY_REWARDS: &str = "rewards";

// Function: vote for a candidate, only if DID hasn't voted yet
#[no_mangle]
pub fn func_vote(ctx: &ScFuncContext) {
    let params = ctx.params();
    let candidate = params.get_string("candidate");
    let did = params.get_string("did");
    if !candidate.exists() || !did.exists() {
        ctx.panic("Missing candidate or DID");
    }
    let candidate = candidate.value();
    let did = did.value();

    // Check if DID has already voted
    let voted = ctx.state().get_bool(&format!("{}/{}", KEY_VOTED, did));
    if voted.value() {
        ctx.panic("This DID has already voted");
    }

    // Record the vote
    let mut votes = ctx.state().get_int(&format!("{}/{}", KEY_VOTES, candidate));
    let current = votes.value();
    votes.set_value(current + 1);

    // Mark DID as voted
    ctx.state().get_bool(&format!("{}/{}", KEY_VOTED, did)).set_value(true);

    // Incentive: reward the DID (e.g., increment a reward counter)
    let mut rewards = ctx.state().get_int(&format!("{}/{}", KEY_REWARDS, did));
    let reward_count = rewards.value();
    rewards.set_value(reward_count + 1);
}

// View: get votes for a candidate
#[no_mangle]
pub fn view_get_votes(ctx: &ScViewContext) {
    let params = ctx.params();
    let candidate = params.get_string("candidate");
    if !candidate.exists() {
        ctx.panic("Missing candidate");
    }
    let candidate = candidate.value();

    let votes = ctx.state().get_int(&format!("{}/{}", KEY_VOTES, candidate));
    ctx.results().get_int("votes").set_value(votes.value());
}

// View: check if a DID has voted
#[no_mangle]
pub fn view_has_voted(ctx: &ScViewContext) {
    let params = ctx.params();
    let did = params.get_string("did");
    if !did.exists() {
        ctx.panic("Missing DID");
    }
    let did = did.value();

    let voted = ctx.state().get_bool(&format!("{}/{}", KEY_VOTED, did));
    ctx.results().get_bool("has_voted").set_value(voted.value());
}

// View: get reward count for a DID
#[no_mangle]
pub fn view_get_rewards(ctx: &ScViewContext) {
    let params = ctx.params();
    let did = params.get_string("did");
    if !did.exists() {
        ctx.panic("Missing DID");
    }
    let did = did.value();

    let rewards = ctx.state().get_int(&format!("{}/{}", KEY_REWARDS, did));
    ctx.results().get_int("rewards").set_value(rewards.value());
} 