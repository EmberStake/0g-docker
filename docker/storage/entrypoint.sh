#!/bin/bash
# This entrypoint updates config files from ENV variable each time container is started,
# so we always using the latest version of env variables in config file without needing to manually modify config file
# Update configs with env variables
sed -i "s#miner_key = \".*\"#miner_key = \"$STORAGE_MINER_PRIVATE_KEY\"#g" /opt/configs/config.toml
sed -i "s#network_enr_address = \".*\"#network_enr_address = \"$STORAGE_ENR_ADDRESS\"#g" /opt/configs/config.toml
sed -i "s#network_enr_tcp_port = .*#network_enr_tcp_port = $STORAGE_NETWORK_ENR_TCP_PORT#g" /opt/configs/config.toml
sed -i "s#network_libp2p_port = .*#network_libp2p_port = $STORAGE_NETWORK_ENR_TCP_PORT#g" /opt/configs/config.toml
sed -i "s#network_enr_udp_port = .*#network_enr_udp_port = $STORAGE_NETWORK_ENR_UDP_PORT#g" /opt/configs/config.toml
sed -i "s#network_discovery_port = .*#network_discovery_port = $STORAGE_NETWORK_ENR_UDP_PORT#g" /opt/configs/config.toml
sed -i "s|network_boot_nodes = .*|network_boot_nodes = $STORAGE_NETWORK_BOOT_NODES|g" /opt/configs/config.toml
sed -i "s#log_contract_address = \".*\"#log_contract_address = \"$STORAGE_LOG_CONTRACT_ADDRESS\"#g" /opt/configs/config.toml
sed -i "s#mine_contract_address = \".*\"#mine_contract_address = \"$STORAGE_MINE_CONTRACT_ADDRESS\"#g" /opt/configs/config.toml
sed -i "s#blockchain_rpc_endpoint = \".*\"#blockchain_rpc_endpoint = \"$STORAGE_BLOCKCHAIN_RPC_ENDPOINT\"#g" /opt/configs/config.toml
sed -i "s#log_sync_start_block_number = .*#log_sync_start_block_number = $STORAGE_LOG_SYNC_START_BLOCK_NUMBER#g" /opt/configs/config.toml
#update log configs
echo "$STORAGE_LOG_CONFIGS" > /opt/configs/log_config
sed -i "s#log_config_file = \".*\"#log_config_file = \"/opt/configs/log_config\"#g" /opt/configs/config.toml

supervisord -c /etc/supervisor/conf.d/supervisord.conf
