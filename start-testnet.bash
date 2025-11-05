#!/bin/bash
docker-compose -f compose.testnet.yaml down
docker-compose -f compose.testnet.yaml up --detach
