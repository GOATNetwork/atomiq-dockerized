sh src.sh
docker build --build-arg TAGS="signrpc walletrpc chainrpc invoicesrpc routerrpc peersrpc" -t atomiqlabs/lnd .
