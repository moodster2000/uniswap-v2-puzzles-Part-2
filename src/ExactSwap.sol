// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";
import {Test, console2} from "forge-std/Test.sol";

contract ExactSwap {
    /**
     *  PERFORM AN SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performExactSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        // your code start here
        IUniswapV2Pair pair = IUniswapV2Pair(pool);
        (uint256 reserve0, uint256 reserve1,) = pair.getReserves();
        (uint256 usdcReserve, uint256 wethReserve) = address(usdc) < address(weth) 
        ? (reserve0, reserve1) 
        : (reserve1, reserve0);
        uint256 usdcAmount = 1337 * 10**6;
        IERC20 wethToken = IERC20(weth);
        uint256 wethBalance = IERC20(weth).balanceOf(address(this));

        uint256 numerator = wethReserve * usdcAmount * 1000;
        uint256 denominator = (usdcReserve - usdcAmount) * 997;
        uint256 wethAmount = (numerator / denominator) + 1; // Add 1 to round up
        
        console2.log(wethAmount);
        wethToken.approve(pool, wethBalance);
        wethToken.transfer(pool, wethAmount);
        pair.swap(usdcAmount, 0, address(this), "");
    }
}
