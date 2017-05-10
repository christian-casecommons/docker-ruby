#!/usr/bin/env bash
set -eo pipefail

# Set default AWS region
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}

# Decrypt and convert KMS encrypted variables
kms=($(env | grep "^KMS_" || true))
for item in "${kms[@]}"
do
  key=$(sed 's|KMS_\([^=]*\)=\(.*\)|\1|' <<< $item)
  value=$(sed 's|\([^=]*\)=\(.*\)|\2|' <<< $item)
  decrypt=$(aws kms decrypt --ciphertext-blob fileb://<(echo "$value" | base64 -d)) 
  export $key="$(echo $decrypt | jq .Plaintext -r | base64 -d)"
done

# Run confd to render config file(s)
confd -onetime -backend env

# Clear HTTP proxy
if [[ -n ${CLEAR_PROXY} ]]
then
  unset http_proxy https_proxy no_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY
fi

# Handoff to application process
exec "$@"