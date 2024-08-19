// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
// @audit the IThunderLoan contract should be implemented by the thunder loan contract!
interface IThunderLoan {
    //@audit Low?Informational ??
    function repay(address token, uint256 amount) external;
}

//✅