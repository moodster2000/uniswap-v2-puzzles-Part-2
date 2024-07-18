// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

contract MultiHop {
    /**
     *  PERFORM A MULTI-HOP SWAP WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 10 MKR.
     *  The challenge is to swap the contract entire MKR balance for ELON token, using WETH as the middleware token.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performMultiHopWithRouter(address mkr, address weth, address elon, uint256 deadline) public {
        // your code start here
        address[] memory path = new address[](2);
        path[0] = mkr;
        path[1] = weth;
        IERC20 mkrToken = IERC20(mkr);
        uint256 mkrBalance = mkrToken.balanceOf(address(this));
        mkrToken.approve(router, mkrBalance);

        IUniswapV2Router(router).swapExactTokensForTokens(mkrBalance, 1, path, address(this),deadline);

        address[] memory path2 = new address[](2);
        path2[0] = weth;
        path2[1] = elon;
        IERC20 wethToken = IERC20(weth);
        uint256 wethBalance = wethToken.balanceOf(address(this));
        wethToken.approve(router, wethBalance);

        IUniswapV2Router(router).swapExactTokensForTokens(wethBalance, 1, path2, address(this),deadline);
    }
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount of input tokens to swap.
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
