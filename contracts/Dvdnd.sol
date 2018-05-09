pragma solidity ^0.4.18;

contract Dvdnd {

  string constant private tokenName = "A Dividend-Paying Token";
  string constant private tokenSymbol = "DPT";
  uint constant private tokenDecimals = 18;
  uint constant private supplyOfTokens = 500;

  uint private currentDividendIndex = 0;
  mapping(address => uint) private lastUserDividendIndex;
  mapping(address => uint) private balances;
  mapping (address => mapping (address => uint)) private allowed;
  address owner;

  constructor() public {
    owner = msg.sender;
    balances[owner] = supplyOfTokens;
  }

  function loadEarnings() public payable {
    require(msg.sender == owner);
    require(msg.value > 0);
    currentDividendIndex++;
  }

  function transferOwnership(address _newOwner) public {
    require(msg.sender == owner);
    owner = _newOwner;
  }

  function awardDividend(address _to) private {
    require(lastUserDividendIndex[_to] != currentDividendIndex);
    uint fractionOfShares = balanceOf(_to) / totalSupply();
    _to.transfer(fractionOfShares);
    lastUserDividendIndex[_to] = currentDividendIndex;
  }

  function redeemDividend() public {
    awardDividend(msg.sender);
  }

  function name() public pure returns (string) {
    return tokenName;
  }

  function symbol() public pure returns (string) {
    return tokenSymbol;
  }

  function decimals() public pure returns (uint) {
    return tokenDecimals;
  }
  
  function totalSupply() public pure returns (uint) {
    return supplyOfTokens;
  }
  
  function transfer(address _to, uint _value) public returns (bool) {
    require(_value <= balances[msg.sender]);
    redeemDividend();
    balances[msg.sender] = balances[msg.sender] - _value;
    balances[_to] = balances[_to] + _value;
    return true;
  }
  
  function balanceOf(address _owner) public view returns (uint) {
    return balances[_owner];
  }

  function transferFrom(address _from, address _to, uint _value) public returns (bool) {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    awardDividend(_from);
    balances[_from] = balances[_from] - _value;
    balances[_to] = balances[_to] + _value;
    allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
    return true;
  }

  function approve(address _spender, uint _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint) {
    return allowed[_owner][_spender];
  }
}