#!/bin/bash

0gchaind config chain-id $CHAIN_ID
0gchaind config keyring-backend test
0gchaind init $MONIKER --chain-id $CHAIN_ID

wget https://github.com/0glabs/0g-chain/releases/download/v0.1.0/genesis.json -O $HOME/.0gchain/config/genesis.json
#Then verify the correctness of the genesis configuration file:
0gchaind validate-genesis

### app.toml changes
# Enable api
sed -i '/^\[api\]/,/^\[/{s/^enable = .*/enable = true/}' $HOME/.0gchain/config/app.toml
sed -i '/^\[api\]/,/^\[/{s/^swagger = .*/swagger = true/}' $HOME/.0gchain/config/app.toml
sed -i '/^\[api\]/,/^\[/{s|^address = .*|address = "tcp://0.0.0.0:1317"|}' $HOME/.0gchain/config/app.toml

# Enable grpc
sed -i '/^\[grpc\]/,/^\[/{s/^enable = .*/enable = true/}' $HOME/.0gchain/config/app.toml
sed -i '/^\[grpc\]/,/^\[/{s|^address = .*|address = "0.0.0.0:9090"|}' $HOME/.0gchain/config/app.toml

# Enable grpc-web
sed -i '/^\[grpc-web\]/,/^\[/{s/^enable = .*/enable = true/}' $HOME/.0gchain/config/app.toml
sed -i '/^\[grpc-web\]/,/^\[/{s|^address = .*|address = "0.0.0.0:9091"|}' $HOME/.0gchain/config/app.toml

# Enable json-rpc
sed -i '/^\[json-rpc\]/,/^\[/{s/^enable = .*/enable = true/}' $HOME/.0gchain/config/app.toml
sed -i '/^\[json-rpc\]/,/^\[/{s|^address = .*|address = "0.0.0.0:8545"|}' $HOME/.0gchain/config/app.toml
sed -i '/^\[json-rpc\]/,/^\[/{s|^ws-address = .*|ws-address = "0.0.0.0:8546"|}' $HOME/.0gchain/config/app.toml



### config.toml changes

sed -i "s|^proxy_app *=.*|proxy_app = \"tcp://0.0.0.0:26658\"|" $HOME/.0gchain/config/config.toml
sed -i "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.0gchain/config/config.toml
# enable indexer
sed -i "s|^indexer *=.*|indexer = \"kv\"|" $HOME/.0gchain/config/config.toml
# configure  node to advertise host public ip to outside peers if provided
sed -i "s|^external_address *=.*|external_address = \"$EXTERNAL_IP:$P2P_PORT\"|" $HOME/.0gchain/config/config.toml
# set RPC listen address
sed -i '/^\[rpc\]/,/^\[/{s|^laddr = .*|laddr = "tcp://0.0.0.0:26657"|}' $HOME/.0gchain/config/app.toml
# set p2p2 listen address
sed -i '/^\[p2p\]/,/^\[/{s|^laddr = .*|laddr = "tcp://0.0.0.0:26656"|}' $HOME/.0gchain/config/app.toml
