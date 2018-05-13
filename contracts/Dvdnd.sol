pragma solidity ^0.4.18;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract Dvdnd is StandardToken {

  string constant public tokenName = "A Dividend-Paying Token";
  string constant public tokenSymbol = "DPT";
  uint constant public decimals = 18;
  uint constant private supplyOfTokens = 500;

  uint private currentDividendIndex = 0;
  mapping(address => uint) private lastUserDividendIndex;
  address private _owner;

  constructor() public {
    _owner = msg.sender;
    // totalSupply_ found in BasicToken.sol in OpenZeppelin
    totalSupply_ = supplyOfTokens;
    balances[_owner] = supplyOfTokens;
  }

  modifier ownerOnly {
    require(msg.sender == owner());
    _;
  }

  function owner() public view returns(address) {
    return _owner;
  }

  function transferOwnership(address _newOwner) public ownerOnly {
    _owner = _newOwner;
  }

  function loadEarnings() public payable ownerOnly{
    require(msg.value > 0);
    currentDividendIndex++;
  }

  function awardDividend(address _to) private {
    require(lastUserDividendIndex[_to] < currentDividendIndex);
    uint fractionOfShares = balanceOf(_to) / totalSupply();
    _to.transfer(address(this).balance * fractionOfShares);
    lastUserDividendIndex[_to] = currentDividendIndex;
  }

  function redeemDividend() public {
    awardDividend(msg.sender);
  }

  function dividendRedeemable(address _user) public view returns (bool) {
    return (
      balanceOf(_user) > 0 && 
      lastUserDividendIndex[_user] < currentDividendIndex
    );
  }
}