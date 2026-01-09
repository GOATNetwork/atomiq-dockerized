
# atomiq node installation

## Pre-requisites
- A linux based machine (preferrably ubuntu 20.04 or 22.04)
- Testnet requirements: 4GB of RAM, 200GB SSD storage
- Mainnet requirements: 6GB of RAM, 1TB SSD storage
- Machine either needs to have a public IP address and be accessible from the public internet or you need to use the [Pinggy tunnel](https://docs.atomiq.exchange/liquidity-provider-nodes-lps/pinggy-tunnel) to forward traffic to your local machine

## Preparations

### Installing docker
Install docker
~~~
sudo apt update
sudo apt install docker.io
~~~

### Setup firewall

Open ports 22, 80, 443 & 8443 in the firewall
~~~
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 8443
sudo ufw enable
~~~

## Installation

Download docker images
~~~
wget https://atomiqbeta.blob.core.windows.net/node/atomiq-node.tar.gz && tar -xvzf atomiq-node.tar.gz images.tar.gz
~~~

Install docker-compose
~~~
sudo ./install-docker-compose.bash
~~~

Run setup script
~~~
sudo ./setup.bash
~~~

Once this completes, it runs all the required software inside docker containers, you can check that all of them are running with
~~~
sudo docker container list
~~~

## Updating

To update the node to the latest version of the docker images you can run the following

Download the latest atomiq node archive
~~~
wget https://atomiqbeta.blob.core.windows.net/node/atomiq-node.tar.gz
~~~

Unpack & run the update script (this will automatically install the new package versions and restart all the docker containers)
~~~
tar -zxvf atomiq-node.tar.gz update.bash && sudo ./update.bash
~~~


## Interact with the node

You can interact with the atomiq node through a CLI (command line interface)
~~~
./lp-cli-testnet
#./lp-cli
~~~

### Stop and start

The full atomiq stack will run automatically on machine boot after installation, should you need to stop or start it you can use the following commands

Stop the atomiq stack with (will stop the containers):
~~~
sudo ./stop-testnet.bash
#sudo ./stop-mainnet.bash
~~~

Start the atomiq stack back up with (will reset the containers, if they are still running)
~~~
sudo ./start-testnet.bash
#sudo ./start-mainnet.bash
~~~

## Using CLI

### Checking node status

We need to wait for the bitcoin node to sync up to the network (download whole bitcoin blockchain, this takes few hours on testnet & up to a day on mainnet).

We can monitor the status of the sync progress with the status command
~~~
> status
GOAT RPC status:
    Status: ready
Bitcoin RPC status:
    Status: verifying blockchain
    Verification progress: 6.8971%  <---- We can see the sync up/verification progress here
    Synced headers: 2812116
    Synced blocks: 549068
LND gRPC status:
    Wallet status: offline
Intermediary status:
    Status: wait_btc_rpc            <---- We can see intermediary node status here, once it's "ready" the node is synced and ready to roll
    Funds: 0.000000000
    Has enough funds (>0.0002 GBTC): no
~~~

### Depositing funds

While the node is syncing we can already deposit funds to the node, using 'getaddress' command we get the GOAT & Bitcoin deposit addresses
~~~
> getaddress
GOAT address: 0x...
Bitcoin address: tb1qy5rl7esxn4nc9mysxwmvgw278w3lwrzwhy3f0f
~~~

After funds are deposited to the wallets we can track the balance with the 'getbalance' command (for BTC balances it only works after bitcoin node is synced)
~~~
> getbalance
GOAT wallet balances (non-trading):
   PegBTC: 0.00000000
   GBTC: 0.00000000
LP Vault balances (trading):
   PegBTC: 0.00000000
   GBTC: 0.00000000
Bitcoin balances (trading):
   BTC: unknown (waiting for bitcoin node sync)
   BTC-LN: unknown (waiting for bitcoin node sync)
~~~

We also have to deposit Assets to the LP vault so they can be used for swaps (this doesn't have to be done with bitcoin assets) - repeat this for all the assets you want to be traded 'deposit <asset:PegBTC/GBTC/GOAT> <amount>'
~~~
> deposit PegBTC 0.001
Transaction sent, signature: 0x... waiting for confirmation...
Deposit transaction confirmed!
~~~

Note: For Goat -> BTC swaps, you don't need to deposit funds to the LP vault. Just transfer funds directly to the BTC wallet.

Now we can check that the assets are really deposited and used for trading
~~~
> getbalance
GOAT wallet balances (non-trading):
   PegBTC: 0.00000000
   GBTC: 0.00000000
LP Vault balances (trading):
   PegBTC: 0.00000000
   GBTC: 0.00000000
Bitcoin balances (trading):
   BTC: unknown (waiting for bitcoin node sync)
   BTC-LN: unknown (waiting for bitcoin node sync)
~~~

## Testing the LP node

After the node is synced up we can test the node via the atomiq frontend, to do this you first need to get the URL of your LP node

~~~
> geturl
Node URL: https://81-17-102-136.nip.io:4000
~~~

To make the atomiq frontend access your node you can use the following frontend URL and replace the `<your node URL>` with the URL obtained by executing the `geturl` command:

`https://app.atomiq.exchange/?UNSAFE_LP_URL=<your node URL>`

This will force the frontend to connect only to your LP node.

## Registering node

Once your node is synced up and ready (we can check that by using the 'status' command in the CLI)
~~~
./lp-cli
Connection to 127.0.0.1 40221 port [tcp/*] succeeded!
Welcome to atomiq intermediary (LP node) CLI!
Type 'help' to get a summary of existing commands!
> status
GOAT RPC status:
    Status: ready
Bitcoin RPC status:
    Status: ready
    Verification progress: 100.0000%
    Synced headers: 2812140
    Synced blocks: 2812140
LND gRPC status:
    Wallet status: ready
Intermediary status:
    Status: ready               <---- We can see that our node is ready now!
    Funds: 1.2930200
    Has enough funds (>0.0002 GOAT): yes
~~~

To be able to process swaps of other atomiq users your node needs to be registered in the atomiq LP node registry.

After confirming the swaps through the LP node work in the previous step, we can now send a request to register our node in the central LP registry with the `register` command. Please be sure to include an e-mail where we can contact you in case there is something wrong with your node.

~~~
> register atomiq@example.com
Success: LP registration request created, URL: https://github.com/adambor/SolLightning-registry/pull/3
~~~

Atomiq will now review your node (check if it is reachable & try swapping through it), you can monitor your node's approval/disapproval status by issuing the `register` command again.

~~~
> register atomiq@example.com
Success: LP registration status: pending, GitHub PR: https://github.com/adambor/SolLightning-registry/pull/3
~~~

Once your node is approved to be listed in the LP registry you will start processing user's swaps!

## Configuration

Your atomiq node comes pre-configured with reasonable default, but in case you want to change the configuration you can find in `config/intermediary/config.yaml` (for mainnet) or `config-testnet/intermediary/config.yaml` (for testnet) folders.
