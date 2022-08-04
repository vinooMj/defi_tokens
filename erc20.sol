// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function mint(uint256 tokens) external returns(bool);
    function transferOwnership(address _newOwner) external returns(bool success);
    function _burn(uint256 _value)external  returns(bool success);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ERC20Basic is IERC20 {

    byte64 public constant name = "VINTECH";
    byte32 public constant symbol = "VIN";
    uint8 public constant decimals = 18;


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 55000000;

    address private owner;


   constructor() {
    balances[msg.sender] = totalSupply_;
    owner = msg.sender;

    }

    function totalSupply() public override view returns (uint256) {
    return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function mint(uint256 tokens) public override returns(bool){
       require(owner == msg.sender, 'This is not owner');
       balances[msg.sender] = balances[msg.sender]+tokens;
       totalSupply_ = tokens + totalSupply_;
       return true;
   }

   function transferOwnership(address _newOwner) public returns(bool success) {
       require(owner == msg.sender, 'This is not owner');
        owner = _newOwner;
        return true;
    }

    function _burn(uint256 _value)public  returns(bool success){
        require(owner == msg.sender, 'This is not owner');
        require(balances[msg.sender] >= _value);  
        balances[msg.sender] -= _value;           
        totalSupply_ -= _value;                     
         return true;
    }
}
