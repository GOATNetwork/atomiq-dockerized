#!/bin/bash
docker-compose -f compose.mainnet.yaml down
docker-compose -f compose.mainnet.yaml up --detach
