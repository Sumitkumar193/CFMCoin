# CFMCoin

Project Details:

Created Token with value of 1 eth = 100 CFM tokens

Contract need to be initiated with 10 eth (to cover 1000 airdrop tokens)

Contract Functions:

  Name() - fetches name of contract.
	
  Symbol()- fetches symbol name.
	
  totalSupply()- fetches total supply.
	
  GetBalance()- Fetches token balance on account.
	
  BalanceOf()- fetches token balance of a address.
  
  transfer()- Transfers CFM token to other addresses.
	
  AirDrop()- Receive upto 20 CFM tokens to users holding more than 50 tokens.
	
  BuyTokens()- User swap eth for CFM tokens (1 eth to 100 CFM tokens).
	
  SellTokens()- Swap desired number of tokens for Eth and user receive back the ether.
	
  Withdraw()- Owner receives the ethereum available in the contract. 
  
  #NOTE: Project is not production ready!
  
  To initialize the contract:
	
      1. Install required node modules -> npm init / npm install
			
      2. Initialize truffle -> truffle init
			
      3. Compile contracts -> truffle compile
			
      4. Migrate contracts to blockchain -> truffle migrate --reset
			
            -> Note: Contract requires minimum 10 ETH to migrate into blockchain (to cover airdrops value for 1000 CFM Tokens)
						
 To use the dApplication:
 
      1. start truffle console -> truffle console
			
      		-> let a = await ERC20Contract.deployed()
			
      3. Now application is ready for using the functions mentioned above.
