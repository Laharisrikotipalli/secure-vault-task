// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuthorizationManager {
    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external returns (bool);
}

contract SecureVault {
    IAuthorizationManager public immutable authManager;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    constructor(address _authManager) {
        authManager = IAuthorizationManager(_authManager);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        address payable recipient,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external {
        require(address(this).balance >= amount, "Insufficient balance");

        bool authorized = authManager.verifyAuthorization(
            address(this),
            recipient,
            amount,
            nonce,
            signature
        );
        require(authorized, "Authorization failed");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "ETH transfer failed");

        emit Withdrawal(recipient, amount);
    }
}
