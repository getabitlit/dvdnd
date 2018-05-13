pragma solidity ^0.4.18;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract Dvdnd is StandardToken {

  string constant public name = "A Dividend-Paying Token";
  string constant public symbol = "DPT";
  uint8 constant public decimals = 18;
  uint constant private supplyOfTokens = 500;

  uint private currentDividendIndex = 0;
  mapping(address => uint) private lastUserDividendIndex;
  address private _custodian;

  constructor() public {
    _custodian = msg.sender;
    // totalSupply_ found in BasicToken.sol in OpenZeppelin
    totalSupply_ = supplyOfTokens;
    balances[_custodian] = totalSupply_;
  }

  modifier custodianOnly {
    require(msg.sender == custodian());
    _;
  }

  function custodian() public view returns (address) {
    return _custodian;
  }

  function transferOwnership(address _newOwner) public custodianOnly {
    _custodian = _newOwner;
  }

  function loadEarnings() public payable custodianOnly{
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