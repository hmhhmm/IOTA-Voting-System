# IOTA Voting Smart Contract (ISC)

This folder contains a minimal IOTA Smart Contract (ISC) for voting, written in Rust and compiled to WebAssembly (Wasm).

## Features
- Vote for a candidate (on-chain)
- Query vote count for a candidate (on-chain)

## Files
- `src/lib.rs` — The contract code
- `Cargo.toml` — Contract manifest

## Build Instructions
1. **Install Rust and Wasm target:**
   ```sh
   rustup target add wasm32-unknown-unknown
   ```
2. **Build the contract:**
   ```sh
   cargo build --target wasm32-unknown-unknown --release
   ```
   The Wasm file will be in `target/wasm32-unknown-unknown/release/iota_voting_contract.wasm`

## Deploying to IOTA ISC (Wasp)
- See the [IOTA Wasp CLI guide](https://wiki.iota.org/smart-contracts/guide/wasp-cli/) for full deployment instructions.
- Example:
  ```sh
  wasp-cli chain deploy-contract ...
  wasp-cli chain post-request ...
  wasp-cli chain call-view ...
  ```

## Integration
- Call the contract from your backend using the IOTA Rust SDK or Wasp CLI.
- Example functions:
  - `func_vote(candidate)` — Vote for a candidate
  - `view_get_votes(candidate)` — Get vote count for a candidate

## Next Steps
- Add authentication, eligibility checks, or more advanced voting logic as needed.
- Integrate with your backend and Flutter frontend. 