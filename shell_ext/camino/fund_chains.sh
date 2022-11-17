#!/bin/bash
source "${HOME}/.shell_ext/camino_chain_functions.sh"

bech32addr=columbus17pysyr6av4n2gf6teqv3kjd5ewdkmncwrhq6qk
hexaddr=0xffCd1238dB10793758c29733e91E784D9bB54651

fail() {
	echo $1;
	exit 15
}

get_tx_status() {
	status=$(cat <<EOT | http --json --body "${capi_url}/ext/bc/X" | jq -r '.result.status'
{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "avm.getTxStatus",
    "params": {
        "txID": "$1"
    }
}
EOT
)

    echo "$status"
}

wait_until_accepted() {
    # Waiting for Tx acceptance
    status="WAIT"

    while [[ $status != "Accepted" ]]
    do
        status="$(get_tx_status $1)"
        echo "Waiting for Tx [$1] - [$status]"
        sleep 1
    done
}

# Check whether node is running
curl -sI --connect-timeout 1 "${capi_url}/ext/health" > /dev/null
res="$?"
[[ $res == "0" ]] || fail "Local node is not running!"

# Check there are funds on X-Chain

# ---------- UNCOMMENT BELOW TO SPECIFY THE AMOUNT ----------
# send_amount=1253100000000000

xbalance=$(xbal "X-${bech32addr}")
echo "Available funds on X-chain: $xbalance"

# Not amount specified - send a `0.1 * quarter`` of the X funds
[ -z "${send_amount}" ] && send_amount=$(( $xbalance / 40 ))

echo "About to send ${send_amount} from X-Chain's deposit of ${xbalance} CAM";
[[ $xbalance -le $send_amount ]] && fail "Not enought funds on X-Chain. Check the genesis settings."

echo "[X -> P]: Export funds out of X-chain"
txid=$(cat <<EOF | http --json --body "${capi_url}/ext/bc/X" | jq -r '.result.txID'
{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.export",
    "params" :{
        "from": ["X-${bech32addr}"],
        "to":"P-${bech32addr}",
        "amount": ${send_amount},
        "assetID": "CAM",
        "changeAddr": "X-${bech32addr}",
        "username":"${ca_username}",
        "password":"${ca_password}"
    }
}
EOF
)

echo "[Check] TxID: ${txid}"
cat <<EOT | http --json --body "${capi_url}/ext/bc/X"
{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "avm.getTxStatus",
    "params": {
        "txID": "$txid"
    }
}
EOT

wait_until_accepted $txid

# Import funds on P-Chain
echo "[X -> P]: Import funds on P-chain"
cat <<EOF | http --json --body "${capi_url}/ext/bc/P"
{
    "method": "platform.importAVAX",
    "params": {
        "username":"${ca_username}",
        "password":"${ca_password}",
        "sourceChain": "X",
        "to":"P-${bech32addr}"
    },
    "jsonrpc": "2.0",
    "id": 1
}
EOF

echo "[X -> C]: Export funds out of X-chain"
txid=$(cat <<EOF | http --json --body "${capi_url}/ext/bc/X" | jq -r '.result.txID'
{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.export",
    "params" :{
        "from": ["X-${bech32addr}"],
        "to":"C-${bech32addr}",
        "amount": ${send_amount},
        "assetID": "CAM",
        "changeAddr": "X-${bech32addr}",
        "username":"${ca_username}",
        "password":"${ca_password}"
    }
}
EOF
)

wait_until_accepted $txid

echo "[X -> C]: Import funds on C-chain"
cat <<EOF | http --json --body "${capi_url}/ext/bc/C/avax"
{
    "method": "avax.import",
    "params": {
        "username":"${ca_username}",
        "password":"${ca_password}",
        "sourceChain": "X",
        "to":"${hexaddr}"
    },
    "jsonrpc": "2.0",
    "id": 1
}
EOF

# No function to wait for C-chain Tx 
echo "Waiting..."
sleep 2

echo "Remaining funds on X-chain:" $(xbal "X-${bech32addr}")
echo "C-chain funded with:" $(bal "${hexaddr}")
