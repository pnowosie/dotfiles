#!/usr/bin/env bash

WORK_DIR="$HOME/Proj/camino/camino-node/build"
LOG_FILE=$(date +'log-%A-%H%M.log')

cd "${WORK_DIR}"
echo "Writing output to ${LOG_FILE}"

args="--public-ip=127.0.0.1 \
   --http-port=9650 \
   --network-id=columbus \
   --bootstrap-ips= \
   --bootstrap-ids= \
   --http-allowed-origins=* \
   --db-dir=local \
   --index-enabled \
   --log-level=trace \
"

./camino-node $args | tee "$LOG_FILE"
