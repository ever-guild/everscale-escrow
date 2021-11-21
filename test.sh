#!/usr/bin/env bash

npx tondev se reset &> /dev/null
npx tonos-cli config --url localhost &> /dev/null
rm -fr *.abi.json *.tvc

. util.sh

createWallet alice
createWallet bob
createWallet eve

npx tondev sol compile Escrow.sol
npx tondev contract deploy Escrow --value 1000000000 &> /dev/null
escrowAddress=$(addressContract Escrow)
echo "Escrow address 0:${escrowAddress}"

submitTransaction alice Escrow _createEscrowId "{\"payer\": \"0:$(addressWallet alice)\", \"payee\": \"0:$(addressWallet bob)\", \"releaser\": \"0:$(addressWallet eve)\", \"amount\": \"10000000000\"}"
submitTransaction alice Escrow depositFor "{\"payee\": \"0:$(addressWallet bob)\", \"releaser\": \"0:$(addressWallet eve)\"}" 10000000000
echo "alice $(balanceWallet alice)"
submitTransaction eve Escrow release "{\"payer\": \"0:$(addressWallet alice)\", \"payee\": \"0:$(addressWallet bob)\", \"amount\": \"10000000000\"}"
echo "bob $(balanceWallet bob)"
