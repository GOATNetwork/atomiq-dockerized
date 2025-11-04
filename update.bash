#!/bin/bash
echo "Unpacking docker images from main archive..."
rm images.tar.gz
tar -xvzf atomiq-node*.tar.gz images.tar.gz

echo "Unpacking docker images..."
rm -r images
tar -xvzf images.tar.gz

echo "Loading docker images..."
docker load --input images/bitcoind.tar
docker load --input images/lnd.tar
docker load --input images/btcrelay.tar
docker load --input images/intermediary.tar

# Ask which environment to setup, store this in a variable
read -p "Which environment to use (mainnet/testnet/testnet4)? " environment

if [ "$environment" != "mainnet" ] && [ "$environment" != "testnet" ] && [ "$environment" != "testnet4" ]; then
	echo "Invalid environment, valid are: mainnet, testnet, testnet4"
	exit 1
fi

echo "Update complete! Running docker-compose to restart the node..."

# Run compose-mainnet.sh for mainnet and compose-testnet.sh for testnet environment
if [ "$environment" == "mainnet" ]; then
	bash start-mainnet.bash
elif [ "$environment" == "testnet" ]; then
	bash start-testnet.bash
else
	bash start-testnet4.bash
fi
