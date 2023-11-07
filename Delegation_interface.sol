pragma solidity ^0.8.0;

contract Delegate {
    address public owner;
    bytes32 private _secret;

    constructor(bytes32 _s) {
        owner = msg.sender;
        _secret = _s;
    }

    function changeOwner(bytes32 secret, address studentWallet) public {
        require(_secret == secret);
        owner = studentWallet;
    }
}

contract Delegation {
    address public owner;
    address public _studentWallet;
    bool public locked = true;
    Delegate delegate;

    constructor(address _sw, address _delegateAddress) {
        owner = msg.sender;
        delegate = Delegate(_delegateAddress);
        _studentWallet = _sw;
    }

    modifier onlyStudent() {
        require(
            msg.sender == _studentWallet,
            "only one student wallet can call"
        );
        _;
    }

    function unlock() public onlyStudent {
        require(owner == _studentWallet);
        locked = false;
    }

    function isSolved() public view returns (bool) {
        return !locked;
    }

    function changeOwnerThroughDelegate(bytes32 secret) public onlyStudent {
        (bool success, ) = address(delegate).delegatecall(
            abi.encodeWithSignature("changeOwner(bytes,address)", secret, _studentWallet)
        );

        require(success, "Change owner failed");
    }
}
