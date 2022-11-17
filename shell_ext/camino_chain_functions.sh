# Camino chain functions

function bal() {
  res=$(cat <<EOF | http --json --body "${capi_url}/ext/bc/C/rpc" | jq -r '.result'
{
    "jsonrpc": "2.0",
    "method": "eth_getBalance",
    "params": [
        "$1",
        "latest"
    ],
    "id": 1
}
EOF
)

  # C-chain has 18-digit decimal precision (number is huge)
  bn=$(echo ${res:2} | tr '[:lower:]' '[:upper:]')
  bn=$(echo "ibase=16; $bn" | bc)
  echo "Balance: ${res} =  $bn CAM"
}

function storat() {
  res=$(cat <<EOF | http --json --body "${capi_url}/ext/bc/C/rpc" | jq -r '.result'
{
    "jsonrpc": "2.0",
    "method": "eth_getStorageAt",
    "params": [
        "$1",
        "0x${2}00000000000000000000000000000000000000000000000000000000000000",
        "latest"
    ],
    "id": 1
}
EOF
)

  echo "Storage [$2]: ${res} $(( $res )) CAM"
}

function xbal() {
  xaddr=$1
  [[ -z "$xaddr" ]] && xaddr="X-columbus17pysyr6av4n2gf6teqv3kjd5ewdkmncwrhq6qk"

  balance=$(cat <<EOF | http --json --body "${capi_url}/ext/bc/X" | jq -r '.result.balance'
{
  "jsonrpc":"2.0",
  "id"     : 1,
  "method" :"avm.getBalance",
  "params" :{
      "address":"${xaddr}",
      "assetID": "CAM"
  }
}
EOF
)

  echo $balance
}
