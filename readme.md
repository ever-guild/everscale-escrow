# Escrow contract on Everscale

```shell
yarn install
yarn test
```

> May use optional env var `EVER_FORMAT=false` for disable format value

```shell
Created wallet 0:9624f7156f14453569cc590cbe3328c2013b4bb93f1e777f2f25ff7eeaa27d03 with 100.00 for alice
Created wallet 0:708770cd5fe2950a1f39e8853b8acc75f093e1c904073e360ff78093ad820f10 with 100.00 for bob
Created wallet 0:ba761b49c7e0ec430a3234ec6959d6318ebb33fc873a19faf917521271d8f082 with 100.00 for carol
Deployed Escrow 0:86942f8ace6d2b7d3185c53c3c6b3b372c97a217702bc1fbc9e2632cabffa243
```

**Escrow release...**
```shell
Escrow 1.00
submitTransaction depositFor {"payee": "0:708770cd5fe2950a1f39e8853b8acc75f093e1c904073e360ff78093ad820f10", "releaser": "0:ba761b49c7e0ec430a3234ec6959d6318ebb33fc873a19faf917521271d8f082"} to Escrow
Escrow 10.99
submitTransaction release {"payer": "0:9624f7156f14453569cc590cbe3328c2013b4bb93f1e777f2f25ff7eeaa27d03", "payee": "0:708770cd5fe2950a1f39e8853b8acc75f093e1c904073e360ff78093ad820f10", "amount": "10000000000"} to Escrow
Escrow 0.99
Alice 89.98
Bob 110.00
Carol 99.97
```

**Escrow refund...**
```shell
Escrow 0.99
submitTransaction depositFor {"payee": "0:708770cd5fe2950a1f39e8853b8acc75f093e1c904073e360ff78093ad820f10", "releaser": "0:ba761b49c7e0ec430a3234ec6959d6318ebb33fc873a19faf917521271d8f082"} to Escrow
Escrow 10.98
submitTransaction refund {"payee": "0:708770cd5fe2950a1f39e8853b8acc75f093e1c904073e360ff78093ad820f10", "releaser": "0:ba761b49c7e0ec430a3234ec6959d6318ebb33fc873a19faf917521271d8f082", "amount": "10000000000"} to Escrow
Escrow 0.97
Alice 89.93
```
