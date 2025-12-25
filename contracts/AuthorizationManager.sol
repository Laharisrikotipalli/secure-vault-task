// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AuthorizationManager {
    using ECDSA for bytes32;

    address public immutable signer;

    mapping(bytes32 => bool) public usedAuthorizations;

    event AuthorizationUsed(bytes32 indexed authHash);

    constructor(address _signer) {
        signer = _signer;
    }

    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external returns (bool) {
        bytes32 authHash = keccak256(
            abi.encodePacked(
                block.chainid,
                vault,
                recipient,
                amount,
                nonce
            )
        );

        require(!usedAuthorizations[authHash], "Authorization already used");

        bytes32 ethSignedMessage = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                authHash
            )
        );

        address recovered = ethSignedMessage.recover(signature);
        require(recovered == signer, "Invalid signature");

        usedAuthorizations[authHash] = true;
        emit AuthorizationUsed(authHash);

        return true;
    }
}
