#!/bin/bash
set -e

# Function to handle termination signals
term_handler() {
    if [ $LITECOIND_PID -ne 0 ]; then
        echo "Stopping litecoind..."
        /home/litecoin/litecoin/bin/litecoin-cli stop
        wait $LITECOIND_PID
    fi
    exit 143; # 128 + 15 -- SIGTERM
}

# Trap termination signals
trap 'kill ${!}; term_handler' SIGTERM

# Ensure litecoin user owns the .litecoin directory
chown -R litecoin:litecoin /home/litecoin/.litecoin

# Update litecoin.conf based on environment variables
CONFIG_FILE="/home/litecoin/.litecoin/litecoin.conf"

# Defaults
echo "daemon=1" > $CONFIG_FILE
echo "peerbloomfilters=1" >> $CONFIG_FILE
echo "disablewallet=1" >> $CONFIG_FILE

# Override defaults with environment variables
for var in $(env | grep ^LITECOIN_); do
    key=$(echo "$var" | sed 's/^LITECOIN_//' | cut -d= -f1)
    value=$(echo "$var" | cut -d= -f2-)
    echo "${key,,}=$value" >> $CONFIG_FILE
done

# Start litecoind in the background
/home/litecoin/litecoin/bin/litecoind -conf=$CONFIG_FILE &

LITECOIND_PID=$!

# Wait for the debug.log file to be created
LOG_FILE="/home/litecoin/.litecoin/debug.log"
TIMEOUT=30
WAIT_INTERVAL=1
ELAPSED=0

while [ ! -f "$LOG_FILE" ] && [ $ELAPSED -lt $TIMEOUT ]; do
    sleep $WAIT_INTERVAL
    ELAPSED=$((ELAPSED + WAIT_INTERVAL))
done

if [ ! -f "$LOG_FILE" ]; then
    echo "Timeout waiting for $LOG_FILE to be created"
    exit 1
fi

# Tail the debug.log file to stdout
tail -f "$LOG_FILE" &
TAIL_PID=$!

# Wait indefinitely or for termination signal
wait $TAIL_PID

