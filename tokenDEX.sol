pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

import "./token.sol";
contract DEX {
   Token token;
   address public tokenAddress;
   constructor(address _token) payable{
      require(msg.value > 0 , "You have to at least deposit something to start an exchange");
      tokenAddress = _token;
      token = Token(address(tokenAddress));
   }
   function buy() payable public {
      uint256 amountTobuy = msg.value;
      uint256 dexBalance = token.balanceOf(address(this));
      require(amountTobuy > 0, "You need to send some USD");
      require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");
      token.transfer(msg.sender, amountTobuy);
   }
   function sell(uint256 amount) public {
      require(amount > 0, "You need to sell at least some tokens");
      uint256 approvedAmt = token.allowance(msg.sender, address(this));
      require(approvedAmt >= amount, "Check the token allowance");
      token.transferFrom(msg.sender, payable(address(this)), amount);
      payable(msg.sender).transfer(amount);
   }
}
