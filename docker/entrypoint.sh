#!/bin/sh
set -e

npx hardhat compile
npx hardhat run scripts/deploy.js --network localhost

tail -f /dev/null
