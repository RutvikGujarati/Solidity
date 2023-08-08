const hre = require("hardhat");

async function main() {
  const Crowdfunding = await hre.ethers.getContractFactory("Crowdfunding");
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const deployerBalanceBefore = await hre.ethers.provider.getBalance(
    deployer.address
  );
  console.log(
    "Account balance before deployment:",
    deployerBalanceBefore.toString()
  );

  const crowdfunding = await Crowdfunding.deploy("Secret Funding", 100, 8);
  await crowdfunding.deployed(); // This line ensures the contract deployment is complete

  console.log("Crowdfunding contract deployed to:", crowdfunding.address);

  const deployerBalanceAfter = await hre.ethers.provider.getBalance(
    deployer.address
  );
  console.log(
    "Account balance after deployment:",
    deployerBalanceAfter.toString()
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
