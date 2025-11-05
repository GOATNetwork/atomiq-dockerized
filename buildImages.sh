cd docker-build

cd bitcoind
sh build.sh
cd ..

cd lnd
sh build.sh
cd ..

cd btcrelay
sh build.sh
cd ..

cd atomiq-intermediary
sh build.sh
cd ..

cd ..
