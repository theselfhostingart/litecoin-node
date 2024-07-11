![Litecoin Docker image](https://i.imgur.com/oWXQrFl.png)
# Goal
The goal of this docker image is to provide a simple, safe and easy to use Litecoin node that anyone can run. Only port 9333 is exposed to the world. This wallet is also accessible by LiteWallet on Android and IOS to make your Litecoin use more private. With your own node, you won't expose your IP to a random node.
# IMPORTANT

If you are using an root user, it's important to create the data folder manually before running this image.
```
mkdir -p $(pwd)/litecoindata
sudo chown -R 1000:1000 $(pwd)/litecoindata
sudo chmod 755 $(pwd)/litecoindata
```
# Usage with normal docker
To run it without docker compose, you can use the following command
```
 docker run -d --name litecoin-node -p 9333:9333 -v $(pwd)/litecoindata:/home/litecoin/.litecoin theselfhostingart/litecoin-node:0.21.3
```
You can change the tag in the end to change the core version.

# Basic example with Docker compose

```
version: '3.7'

services:
  litecoin:
    image: theselfhostingart/litecoin-node:0.21.3
    container_name: litecoin-node
    volumes:
      - ./litecoindata:/home/litecoin/.litecoin
    ports:
      - "9333:9333"
    restart: always
    environment:
      - LITECOIN_RPCUSER=yourusername
      - LITECOIN_RPCPASSWORD=yourpassword
```

*Remember to create the folder before using it as docker compose or as a docker daemon.*

# Checking logs
You can easily check the litecoin debug.log with:
```
docker logs -f litecoin-node
```

# Connecting to your LiteWallet

To connect your node with LiteWallet it's quite simple. You can go to Settings -> Advanced Settings -> Litecoin Nodes -> Switch to Manual Mode. Now, input the IP address of your node and you are good to go!

# How do I verify is this code is safe? 

You can build it by yourself. The code is really simple and it is published here: https://github.com/theselfhostingart/litecoin-node

Feel free to open any issues or make suggestions too!
