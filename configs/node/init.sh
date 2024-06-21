#!/bin/bash

0gchaind config chain-id $CHAIN_ID
0gchaind config keyring-backend test
0gchaind init $MONIKER --chain-id $CHAIN_ID

wget https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json -O $HOME/.0gchain/config/genesis.json
#Then verify the correctness of the genesis configuration file:
0gchaind validate-genesis

### app.toml changes
# Enable api
sed -i '/^\[api\]/,/^\[/{s/^swagger = .*/swagger = true/}' $HOME/.0gchain/config/app.toml


### config.toml changes
sed -i "s|^indexer *=.*|indexer = \"kv\"|" $HOME/.0gchain/config/config.toml
