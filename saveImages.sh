rm images.tar.gz
rm -r images/
mkdir images/
docker image save -o images/bitcoind.tar atomiqlabs/bitcoind
docker image save -o images/btcrelay.tar atomiqlabs/btcrelay
docker image save -o images/intermediary.tar atomiqlabs/intermediary
docker image save -o images/lnd.tar atomiqlabs/lnd
tar czf images.tar.gz images/
rm -r images/
