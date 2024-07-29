#!/bin/bash
# This entrypoint updates config files from ENV variable each time container is started,
# so we always using the latest version of env variables in config file without needing to manually modify config file
# Update configs with env variables
sed -i "s#blockchain_rpc_endpoint = \".*\"#blockchain_rpc_endpoint = \"$KV_BLOCKCHAIN_RPC_ENDPOINT\"#g" /config/config.toml
sed -i "s#log_contract_address = \".*\"#log_contract_address = \"$KV_LOG_CONTRACT_ADDRESS\"#g" /config/config.toml
sed -i "s#log_sync_start_block_number = .*#log_sync_start_block_number = $KV_LOG_SYNC_START_BLOCK_NUMBER#g" /config/config.toml
sed -i "s#zgs_node_urls = \".*\"#zgs_node_urls = \"$KV_ZGS_NODE_URLS\"#g" /config/config.toml

#update log configs
echo "$KV_LOG_CONFIGS" > /config/log_config
sed -i "s#log_config_file = \".*\"#log_config_file = \"/config/log_config\"#g" /config/config.toml

/usr/local/bin/zgs_kv --config /config/config.toml
