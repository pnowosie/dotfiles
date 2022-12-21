#!/bin/bash

source "$HOME/.shell_ext/utility.sh"

generate_post_data()
{
  cat <<EOF
{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"$1",
    "params" :{
        "username": "${ca_username}",
        "password": "${ca_password}",
        "privateKey":"${ca_privkey}"
    }
}
EOF
}

# Check whether node is running
curl -sI --connect-timeout 1 "${capi_url}/ext/health" > /dev/null
res="$?"
[[ $res == "0" ]] || fail "Local node is not running!"

generate_post_data "keystore.createUser" | http --json --body "${capi_url}/ext/keystore"
generate_post_data "avm.importKey" | http --json --body "${capi_url}/ext/bc/X"
generate_post_data "platform.importKey" | http --json --body "${capi_url}/ext/bc/P"
generate_post_data "avax.importKey" | http --json --body "${capi_url}/ext/bc/C/avax"
