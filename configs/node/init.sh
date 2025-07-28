#!/bin/bash

0gchaind init $MONIKER  --home /tmp/0gchaind


cp /tmp/0gchaind/data/priv_validator_state.json $DAEMON_HOME/data/
cp /tmp/0gchaind/config/node_key.json $DAEMON_HOME/config/
cp /tmp/0gchaind/config/priv_validator_key.json $DAEMON_HOME/config/

