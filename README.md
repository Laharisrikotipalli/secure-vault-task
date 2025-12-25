# Secure Vault System

A **two-contract Ethereum secure vault system** that enables **safe ETH withdrawals** using **off-chain authorization**, **on-chain verification**, and **replay protection**.

The system is fully automated and deploys itself on a **local blockchain using Docker**.

---

##  Overview

This project separates **authorization logic** from **fund custody** to improve security and auditability.

Authorization decisions are made **off-chain**  
Verification and execution happen **on-chain**  
Replay attacks are explicitly prevented  

---

## Architecture

### AuthorizationManager
Stores a **trusted signer address**  
Verifies off-chain **ECDSA signatures**  
Enforces **exactly-once authorization**  
Prevents **replay attacks** by tracking used hashes  

### SecureVault
Holds ETH  
Accepts deposits via `receive()`  
Executes withdrawals **only after authorization**  
Delegates all verification logic to `AuthorizationManager`  
Does **not** verify signatures itself  

---

## Authorization Design

Withdrawals are authorized **off-chain** using a signed message.

### Authorization Hash Inputs
The authorization hash is constructed using:

 `chainId`  
 `vault address`  
 `recipient address`  
 `withdrawal amount`  
 `nonce`  

### Authorization Flow
Hash is generated off-chain  
Hash is signed by the **trusted signer**  
Signature is submitted on-chain  
Signature is verified inside `AuthorizationManager`  

This design ensures:
No private keys are stored on-chain  
Flexible off-chain policy enforcement  
Minimal on-chain attack surface  

---

##  Replay Protection

Replay protection is enforced by design.

Each authorization hash is stored after first use  
Reusing the same hash **reverts the transaction**  
Guarantees **exactly-once execution**  

This protects against:
Signature reuse  
Transaction replay  
Double withdrawals  

---

## 🐳 Running Locally (Docker)

### Prerequisites
Docker  
Docker Compose  

### Run the system

```bash
docker-compose up --build
```
**What this command does automatically**

Starts a local Ethereum blockchain (Ganache)
Compiles all smart contracts
Deploys AuthorizationManager
Deploys SecureVault
Prints deployed contract addresses

---
## Repository Structure
```
secure-vault-task/
├── contracts/
│   ├── AuthorizationManager.sol
│   └── SecureVault.sol
├── scripts/
│   └── deploy.js
├── docker/
│   └── entrypoint.sh
├── Dockerfile
├── docker-compose.yml
├── hardhat.config.js
├── package.json
├── package-lock.json
└── README.md
```
---
## Security Considerations

Signature verification uses ECDSA recovery
Replay protection prevents double-spending
Authorization logic is isolated for auditability
Vault does not trust callers directly
Withdrawal execution requires explicit approval

---
## Assumptions

A single trusted signer exists
Signing keys are securely managed off-chain
Each withdrawal is individually authorized

---
## Known Limitations

No signer rotation mechanism
No batch withdrawals
No on-chain role management beyond signer trust

These trade-offs were made intentionally for clarity and security focus.


