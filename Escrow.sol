//SPDX-License-Identifier: Unlicense
pragma ton-solidity >= 0.51.0;
pragma AbiHeader expire;

enum Status {
    Opened,
    Refunded,
    Closed
}

contract Escrow {
    event EscrowStatus(
        Status status,
        address payer,
        address payee,
        address releaser,
        uint256 amount
    );

    mapping(uint256 => bool) private _releaseList;

    modifier accept() {
        tvm.accept();
        _;
    }

    function depositFor(address payee, address releaser)
    accept
    external
    payable
    {
        require(msg.value > 0, 1000, "Escrow: Must be more zero");
        uint256 escrowId = _createEscrowId(
            msg.sender,
            payee,
            releaser,
            msg.value
        );
        require(!_releaseList[escrowId], 1000, "Escrow: Not released");
        _releaseList[escrowId] = true;
        emit EscrowStatus(
            Status.Opened,
            msg.sender,
            payee,
            releaser,
            msg.value
        );
    }

    function release(
        address payer,
        address payee,
        uint128 amount
    )
    accept
    external
    {
        _release(payer, payee, msg.sender, amount);
        payee.transfer(amount, true, 3);
        emit EscrowStatus(Status.Closed, payer, payee, msg.sender, amount);
    }

    function refund(
        address payee,
        address releaser,
        uint128 amount
    )
    accept
    external
    {
        _release(msg.sender, payee, releaser, amount);
        msg.sender.transfer(amount, true, 3);
        emit EscrowStatus(Status.Refunded, msg.sender, payee, releaser, amount);
    }

    function _release(
        address payer,
        address payee,
        address releaser,
        uint256 amount
    ) private {
        uint256 escrowId = _createEscrowId(payer, payee, releaser, amount);
        require(_releaseList[escrowId], 1000, "Escrow: Not find release");
        delete _releaseList[escrowId];
    }

    function _createEscrowId(
        address payer,
        address payee,
        address releaser,
        uint256 amount
    ) private pure returns (uint256) {
        TvmBuilder builder;
        builder.store(payer, payee, releaser, amount);
        return tvm.hash(builder.toCell());
    }
}
