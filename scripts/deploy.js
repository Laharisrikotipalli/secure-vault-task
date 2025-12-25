const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying with account:", deployer.address);

  const network = await hre.ethers.provider.getNetwork();
  console.log("Chain ID:", network.chainId);

  // Deploy AuthorizationManager
  const AuthManager = await hre.ethers.getContractFactory("AuthorizationManager");
  const authManager = await AuthManager.deploy(deployer.address);
  await authManager.waitForDeployment();

  const authAddress = await authManager.getAddress();
  console.log("AuthorizationManager deployed at:", authAddress);

  // Deploy SecureVault
  const Vault = await hre.ethers.getContractFactory("SecureVault");
  const vault = await Vault.deploy(authAddress);
  await vault.waitForDeployment();

  const vaultAddress = await vault.getAddress();
  console.log("SecureVault deployed at:", vaultAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
