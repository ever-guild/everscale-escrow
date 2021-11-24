#!/usr/bin/env bash

npx tondev se reset &> /dev/null
rm -fr *.abi.json *.tvc *.log

. util/util.sh

createWallet alice
createWallet bob
createWallet carol

npx tondev sol compile Escrow.sol
npx tondev contract deploy Escrow --value 1014857001 >> tondev.log 2>&1
escrowAddress=$(addressContract Escrow)
echo "Deployed Escrow 0:${escrowAddress}"

echo "Escrow release..."
echo "Escrow $(balanceContract Escrow)"
submitTransaction alice Escrow depositFor "{\"payee\": \"0:$(addressWallet bob)\", \"releaser\": \"0:$(addressWallet carol)\"}" 10000000000
echo "Escrow $(balanceContract Escrow)"
submitTransaction carol Escrow release "{\"payer\": \"0:$(addressWallet alice)\", \"payee\": \"0:$(addressWallet bob)\", \"amount\": \"10000000000\"}"
echo "Escrow $(balanceContract Escrow)"
echo "Alice $(balanceWallet alice)"
echo "Bob $(balanceWallet bob)"
echo "Carol $(balanceWallet carol)"

echo "Escrow refund..."
echo "Escrow $(balanceContract Escrow)"
submitTransaction alice Escrow depositFor "{\"payee\": \"0:$(addressWallet bob)\", \"releaser\": \"0:$(addressWallet carol)\"}" 10000000000
echo "Escrow $(balanceContract Escrow)"
submitTransaction alice Escrow refund  "{\"payee\": \"0:$(addressWallet bob)\", \"releaser\": \"0:$(addressWallet carol)\", \"amount\": \"10000000000\"}"
echo "Escrow $(balanceContract Escrow)"
echo "Alice $(balanceWallet alice)"
echo "Bob $(balanceWallet bob)"
echo "Carol $(balanceWallet carol)"
