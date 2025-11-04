#!/bin/bash
docker-compose -f compose.testnet4.yaml down
docker-compose -f compose.testnet4.yaml up --detach
