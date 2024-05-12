#!/bin/bash

0gchaind config chain-id $CHAIN_ID
0gchaind config keyring-backend test
0gchaind init $MONIKER --chain-id $CHAIN_ID

wget https://github.com/0glabs/0g-chain/releases/download/v0.1.0/genesis.json -O $HOME/.0gchain/config/genesis.json
#Then verify the correctness of the genesis configuration file:
0gchaind validate-genesis


sed -i "s#seeds = \".*\"#seeds = \"$SEEDS\"#g" $HOME/.0gchain/config/config.toml

## configure  node to advertise host public ip to outside peers if provided
echo "Advertising public ip $EXTERNAL_IP"
sed -i "s#external_address = \".*\"#external_address = \"$EXTERNAL_IP:$P2P_PORT\"#g" $HOME/.0gchain/config/config.toml
sed -i "s#laddr = \"tcp://.*:26657\"#laddr = \"tcp://0.0.0.0:26657\"#g" $HOME/.0gchain/config/config.toml
#set gas price
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml
# enable index
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.0gchain/config/config.toml
