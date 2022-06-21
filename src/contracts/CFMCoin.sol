pragma solidity >= 0.7.0 < 0.9.0;

//"SPDX-License-Identifier: UNLICENSED

contract ERC20Contract {
    string private _name;
    string private _symbol;
    address private owner;
    uint256 private airdropSupply;  //Keeps track of airdrops
    uint256 private _tokenSupply;   //Total tokens supply
    uint256 private amountPerEth;   //1 eth = number of tokens
    mapping(address => uint256) private _balance;    //Map to keep track of balances
    mapping(address => bool) private _receivedAirdrop;  //Map to keep track of accounts redeemed balance
    event Transfer(address indexed _from, address indexed _to, uint256 _value); //Broadcast transactions


    constructor() payable checkFunds {
        owner = msg.sender;
        _name = "CoinForMobiloitte";
        _symbol = "CFM";
        _tokenSupply = 10000;
        airdropSupply = 1000;
        amountPerEth = 100;
        _balance[address(this)] = 9000;
    }

    modifier checkFunds {
        require(msg.value >= 10 ether, "Did not received enough funds to cover airdrop!");
        _;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "You are not authorized!");
        _;
    }

    modifier hasReceivedAirdrop {
        require(_receivedAirdrop[msg.sender] != true, "Account already redeemed the airdrop!");
        _;
    }

    function name() public view returns(string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function totalSupply() public view returns(uint256) {
        return _tokenSupply;
    }

    function getBalance() public view returns(uint) {
        return _balance[msg.sender];
    }
    
    function balanceOf(address account) public view returns(uint) {
        return _balance[account];
    }

    //First 100 unique users can receive the airdrop of CFM token
    function airdrop() public hasReceivedAirdrop {
        require(_balance[msg.sender] == 0 , "Airdrop tokens to only new addresses");
        require(airdropSupply >= 0, "Airdrop is over!");
        _receivedAirdrop[msg.sender] = true;
        airdropSupply -= 10;
        _balance[msg.sender] += 10;
        emit Transfer(address(0x0), msg.sender, 10);   
    }

    //transfer function to handle transactions on blockchain
    function transfer(address _to, uint256 _value) public returns (bool){
        address _owner = msg.sender;
        require(_to != _owner, "Transferring token to your own account!");
        require(_to != address(0x0), "Transferring token to invalid address!");
        require(_balance[_owner] >= _value, "Amount exceeds balance in account!");
        _balance[address(this)] -= _value;
        _balance[_to] += _value;
        emit Transfer(_owner, _to, _value);
        return true;
    }

    //Receive tokens to contract while selling
    function transferFrom(address _from , address _to, uint256 _value) private returns (bool) {
        _balance[_from] -= _value;
        _balance[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    //Tokens can be purchased with this function
    function buyTokens() public payable returns(bool) {
        uint256 minVal = 1 ether;
        require(msg.value >= minVal, "Minimum buy value requires more than 1 ethers" );
        uint256 amountToPurchase = msg.value * amountPerEth / 1 ether;  // convert wei (msg.sender) into 1 ether
        require(_balance[address(this)] >= amountToPurchase, "Contract does not have enough tokens to swap.");
        _balance[address(this)] -= amountToPurchase;
        _balance[msg.sender] += amountToPurchase;
        emit Transfer(address(this), msg.sender, amountToPurchase);
        return true;
    }

    //Tokens can be sold with this function
    function sellTokens(uint256 amount) public  {
        require(amount >= 50, "Tokens to sell are lower than required amount.");
        //Calculate amounts in eth for swap
        uint256 contractBalance = address(this).balance;
        uint256 tokenToEth = amount / amountPerEth * 1 ether;
        require(contractBalance >= tokenToEth, "Contract does not have enough balance for swap!"); //Checks if balance is enough

        (bool success) = transferFrom(msg.sender, address(this), amount);   //Debit the tokens 
        require(success, "Transaction cannot be completed try again later!");

        address payable _to = payable(msg.sender);
        (success,) = _to.call{value: tokenToEth}("");    //Send eth back to seller
        require(success, "ERR : Failed to send ETH to the user");
    }

    //Ethers can be withdrawn from contract to owner
    function withdraw() public onlyOwner {
        //check balance
        uint256 ownerBalance = address(this).balance;
        require(ownerBalance > 0, "Owner has not balance to withdraw");
        //Send transaction
        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send user balance back to the owner");
    }
}