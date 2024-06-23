### 0G Dockerized
This repository is starting point to run a [Zero-Gravity](https://0g.ai/) Node/Validator using docker compose

*Storage node and KV nodes will be added soon* 

---
## Getting started
copy `.env.sample` to `.env` and fill it with your variables

build the image 
```bash
docker compose --profile node build
```

run and exec into an ephemeral container:
```bash
docker compose --profile node run --rm --entrypoint /bin/bash node
```
inside the container run init script
```bash
/init.sh
```
if you want modify config files further edit the config manually
```bash
nano $HOME/.0gchain/config/config.toml
```

then create a new wallet or import one

```bash
0gchaind keys add $WALLET_NAME --recover
```
to import your previous node_key.json or other files you can either : 
- use `docker cp` command in another terminal to copy your files
- or manually edit files using `nano` and replace the content of your keys with your backups


Now exit the container and run node service in background

```bash
docker compose  --profile node up -d
```

## Restore snapshot or use state sync
first stop the running service
```bash
docker compose stop node
```
run an ephemeral container again 
```bash
docker compose run --rm --entrypoint /bin/bash node
```
inside this container run your snapshot/state sync commands, then exit and run service again
```bash
docker compose up -d
```

### Run arbitrary commands inside the node container
to run any commands using `0gchaind`, just exec into running node service
```bash
docker compose exec node bash
```
here you have access to `0gchaind` binary


# Storage Node

modify the variables in `.env` file under Storage configs section with your desired variables.   
Important ones are:    
- `STORAGE_MINER_PRIVATE_KEY` This requires a private without key funded by testnet tokens from faucet. you have two ways to get this private key
  - create a fresh wallet on metamask, export private key and **REMOVE LEADING 0X**
  - or use your validator account private key. export it by `0gchaind keys unsafe-export-eth-key $WALLET_NAME`
- `STORAGE_ENR_ADDRESS` Your server public IP address
- `STORAGE_BLOCKCHAIN_RPC_ENDPOINT` If you are running a node/validator using this compose file, you can directly connect to it by setting this to `http://node:8545` , otherwise use a public RPC endpoint   

##### build the image
```bash
docker compose --profile storage build
```
##### run the container in background 

```shell
docker compose --profile storage up -d storage-node
```
##### check logs

```shell
docker compose --profile storage logs -f --since 1m storage-node
```
make sure wallet is funded by a0gi

# KV Node
modify the variables in `.env` file under Storage configs section with your desired variables.   
Important ones are:

- `STORAGE_BLOCKCHAIN_RPC_ENDPOINT` If you are running a node/validator using this compose file, you can directly connect to it by setting this to `http://node:8545` , otherwise use a public RPC endpoint   
- `KV_ZGS_NODE_URLS` If you are running a storage node using this compose file, you can directly connect to it by setting this to `http://storage-node:5678` , otherwise use a public **Storage** node RPC endpoint   

##### build the image
```bash
docker compose --profile kv build
```
##### run the container in background

```shell
docker compose --profile kv up -d kv-node
```
##### check logs

```shell
docker compose --profile kv logs -f --since 1m kv-node
```
