### 0G Dockerized
This repository is a complete toolkit to run [Zero-Gravity](https://0g.ai/) Nodes using docker with minimal effort. includes :
- Node/Validator
- Storage Node
- Storage KV



### How to use
You can find documentation about this repository on our website at [EmberStake - ZeroGravity](https://docs.emberstake.xyz/networks/0g-zero-gravity/guide)

### Known Issues & Limitation

it seems zks_node logs can't be piped to stderr/stdout , so we utilized some custom scripts and supervisor to workaround it.
if the zks_node process dies the container will continue to live as normal, because the logger script is yet alive. it will be resolved as soon as https://github.com/0glabs/0g-storage-node/issues/91 gets resolved.
---

Stake with us at https://emberstake.xyz
