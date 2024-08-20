// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

// e this is probably the interface to work with poolfactory.sol from tswap
//@Question why are we using Tswap here?
interface IPoolFactory {
    function getPool(address tokenAddress) external view returns (address);
}


//✅