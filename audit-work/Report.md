<!-- @format -->

## [H-1] Erronoues `updateExchangeRate` in the desposit function causes protocol to think it has more fees than it really does, which blocks redemption and incprrectly sets the exchange rate.

**Description** In the thunderLoan system , the `exchangerate` is reponsible for calculating the exchagne rate between assestToken and underlying tokens.In a way it is responsible for keeping track of how many fees to give to liqudity providers.
However, the `deposite` function, update the rate, without collecting any fees! This update should be removed.

```Javascript

        function deposit(
        IERC20 token,
        uint256 amount
    ) external revertIfZero(amount) revertIfNotAllowedToken(token) {
        AssetToken assetToken = s_tokenToAssetToken[token];
        uint256 exchangeRate = assetToken.getExchangeRate();
        uint256 mintAmount = (amount * assetToken.EXCHANGE_RATE_PRECISION()) /
            exchangeRate;
        emit Deposit(msg.sender, token, amount);
        assetToken.mint(msg.sender, mintAmount);
@>      uint256 calculatedFee = getCalculatedFee(token, amount);
@>      assetToken.updateExchangeRate(calculatedFee);
        token.safeTransferFrom(msg.sender, address(assetToken), amount);
    }

```

**Impact** There are several function Impacts toh thiss bug. 1. The `redeem` function is blocked, because the protoccol thinks the owed token is mroe than ithas. 2. Rewards are incorrectly calculated, leading liquidity providers potentially getting way more of less then deserved.

**Proof of Concept**

1. LP deposite
2. User takes out the falsh loans.
3. It is now impossible for LP to redeem.

Place the following into `ThunderLoan.t.sol`

```Javascript
    function testRedeemAfterLoan() public setAllowedToken hasDeposits{
        uint256 amountToBorrow = AMOUNT * 10;
        uint256 calculatedFee = thunderLoan.getCalculatedFee(tokenA, amountToBorrow);
        vm.startPrank(user);
        tokenA.mint(address(mockFlashLoanReceiver), calculatedFee);
        thunderLoan.flashloan(address(mockFlashLoanReceiver), tokenA, amountToBorrow, "");
        vm.stopPrank();

        uint256 amountToRedeem = type(uint256).max;
        vm.startPrank(liquidityProvider);
        thunderLoan.redeem(tokenA, amountToRedeem);
    }
```

**Recommended Mitigation** Remove the incorrect update of the exchange rate in the `deposit` function.

```diff

    function deposit(
        IERC20 token,
        uint256 amount
    ) external revertIfZero(amount) revertIfNotAllowedToken(token) {
        AssetToken assetToken = s_tokenToAssetToken[token];
        uint256 exchangeRate = assetToken.getExchangeRate();
        uint256 mintAmount = (amount * assetToken.EXCHANGE_RATE_PRECISION()) /
            exchangeRate;
        emit Deposit(msg.sender, token, amount);
        assetToken.mint(msg.sender, mintAmount);
-       uint256 calculatedFee = getCalculatedFee(token, amount);
-       assetToken.updateExchangeRate(calculatedFee);
        token.safeTransferFrom(msg.sender, address(assetToken), amount);
    }

```
