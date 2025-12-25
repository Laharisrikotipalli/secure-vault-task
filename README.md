# Secure Vault System

This project implements a two-contract secure vault system with off-chain authorization and on-chain replay protection.

## Architecture

- **AuthorizationManager**
  - Verifies off-chain signatures
  - Enforces exactly-once authorization
  - Prevents replay attacks

- **SecureVault**
  - Holds ETH
  - Executes withdrawals only after authorization
  - Does not verify signatures itself

## Authorization Design

An authorization hash is created off-chain using:

- chainId
- vault address
- recipient address
- withdrawal amount
- nonce

The hash is signed by a trusted signer and verified on-chain.

## Replay Protection

Each authorization hash is stored after use.
Reusing the same authorization will fail.

## Running Locally (Docker)

```bash
docker-compose up --build
