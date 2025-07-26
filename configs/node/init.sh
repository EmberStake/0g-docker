#!/bin/bash

#0gchaind config chain-id $CHAIN_ID
#0gchaind config keyring-backend test
0gchaind init $MONIKER  --home /tmp/0gchaind


cp /tmp/0gchaind/data/priv_validator_state.json $DAEMON_HOME/data/
cp /tmp/0gchaind/config/node_key.json $DAEMON_HOME/config/
cp /tmp/0gchaind/config/priv_validator_key.json $DAEMON_HOME/config/


### app.toml changes
# it is not possible to modify below configs through cli flags, so we set their default value here
#sed -i '/^\[api\]/,/^\[/{s/^swagger = .*/swagger = true/}' $DAEMON_HOME/config/app.toml
#sed -i '/^\[api\]/,/^\[/{s|^address = .*|address = "tcp://0.0.0.0:1317"|}' $DAEMON_HOME/config/app.toml
sed -i '/^\[beacon-kit.engine\]/,/^\[/{s|^rpc-dial-url = .*|rpc-dial-url = "http://geth:8551"|}' $DAEMON_HOME/config/app.toml


### config.toml changes
#sed -i "s|^indexer *=.*|indexer = \"null\"|" $DAEMON_HOME/config/config.toml
