-include .env

build:; forge build

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(ALCHEMY_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(SEPOLIA_API_KEY) -vvvv