var ERC20Contract = artifacts.require("ERC20Contract"); //Contract name -> ERC20Contract

module.exports = (deployer, accounts) => {
    if (accounts) {
        // Create contract with 10 ether to cover airdrops
        deployer.deploy(ERC20Contract, { value: "10000000000000000000" });
    };
};