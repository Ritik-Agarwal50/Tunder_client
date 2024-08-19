// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.20;

//@audit info unused import
// it's bad practice to edit main code base for test/mocks, we must remove the import from `MockFlashLoanReceiver.sol`

import { IThunderLoan } from "./IThunderLoan.sol";

/**
 * @dev Inspired by Aave:
 * https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/interfaces/IFlashLoanReceiver.sol
 */
interface IFlashLoanReceiver {
        // q is the token, the token that brlong borrowedd?
        // @audit where the netspec??
        // q amounnt is the amount of token?
        //looks pretty good to me
    function executeOperation(
        address token,
        uint256 amount,
        uint256 fee,
        address initiator,
        bytes calldata params
    )
        external
        returns (bool);
}
//✅