#!/bin/bash

0gchaind config chain-id $CHAIN_ID
0gchaind config keyring-backend test
0gchaind init $MONIKER --chain-id $CHAIN_ID

wget https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json -O $HOME/.0gchain/config/genesis.json
#Then verify the correctness of the genesis configuration file:
0gchaind validate-genesis

### app.toml changes
# it is not possible to modify below configs through cli flags, so we set their default value here
sed -i '/^\[api\]/,/^\[/{s/^swagger = .*/swagger = true/}' $HOME/.0gchain/config/app.toml
sed -i '/^\[api\]/,/^\[/{s|^address = .*|address = "tcp://0.0.0.0:1317"|}' $HOME/.0gchain/config/app.toml


### config.toml changes
sed -i "s|^indexer *=.*|indexer = \"null\"|" $HOME/.0gchain/config/config.toml
