#!/bin/bash
# This entrypoint updates config files from ENV variable each time container is started,
# so we always using the latest version of env variables in config file without needing to manually modify config file
# Update configs with env variables
sed -i "s#log_level = \".*\"#log_level = \"$DA_NODE_LOG_LEVEL\"#g" /config/config.toml
sed -i "s#eth_rpc_endpoint = \".*\"#eth_rpc_endpoint = \"$DA_NODE_ETH_RPC_ENDPOINT\"#g" /config/config.toml
sed -i "s#socket_address = \".*\"#socket_address = \"$DA_NODE_SOCKET_ADDR:$DA_NODE_SOCKET_PORT\"#g" /config/config.toml
sed -i "s#da_entrance_address = \".*\"#da_entrance_address = \"$DA_NODE_ENTRANCE_CONTRACT\"#g" /config/config.toml
sed -i "s#start_block_number = .*#start_block_number = $DA_NODE_START_BLOCK_NUMBER#g" /config/config.toml
sed -i "s#signer_bls_private_key = \".*\"#signer_bls_private_key = \"$DA_NODE_SIGNER_BLS_PRIVATE_KEY\"#g" /config/config.toml
sed -i "s#signer_eth_private_key = \".*\"#signer_eth_private_key = \"$DA_NODE_SIGNER_ETH_PRIVATE_KEY\"#g" /config/config.toml
sed -i "s#enable_das = \".*\"#enable_das = \"$DA_NODE_ENABLE_DAS\"#g" /config/config.toml

/usr/local/bin/zgda_node --config /config/config.toml
