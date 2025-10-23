cast wallet address --private-key 0x12d7de8621a77640c9241b2595ba78ce443d05e94090365ab3bb5e19df82c625     cast balance 0x<COINBASE> --rpc-url http://$(kurtosis port print cdks cdk-erigon-rpc-001 rpc)       cast send --legacy \
  --rpc-url $(kurtosis port print cdk-erigon cdk-erigon-rpc-001 rpc) \
  --private-key 0x12d7de8621a77640c9241b2595ba78ce443d05e94090365ab3bb5e19df82c625 \
  --gas-price 0 --gas-limit 21000 --value 1 0xDESTINO


0xE34aaF64b29273B7D567FCFc40544c014EEe9970
