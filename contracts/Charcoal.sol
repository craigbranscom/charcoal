pragma solidity ^0.4.17;

//import "./ERC20.sol";

/// @title Charcoal
/// @author Stephen Craig Branscom
/// @notice Contract for Charcoal, a loyalty points system for Tradeblazer
contract Charcoal {
    
    /// @notice Final variables
    string public constant name = "Charcoal";
    string public constant symbol = "CHAR";
    uint8 public constant decimals = 18;
    
    /// @notice State variables
    uint256 public totalSupply;
    
    /// @notice Balances of each account
    mapping (address => uint256) public balanceOf;
    
    /// @notice List of accounts allowed to make a transfer to another account
    mapping (address => mapping (address => uint256)) public allowance;
    
    /// @notice Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value);
    
    /// @notice Charcoal Constructor
    function Charcoal() public {
        totalSupply = 12011;
        balanceOf[this] = 12011;
    }
    
    /// @notice 
    /// @return uint256
    function totalSupply() external view returns (uint256) {
        return totalSupply;
    }
    
    /// @notice
    /// @param address _owner
    /// @return uint256
    function balanceOf(address _owner) external view returns (uint256) {
        return balanceOf[_owner];
    }
    
    
    /// @notice
    /// @param address _to, uint _value
    /// @return bool
    function transfer(address _to, uint _value) public returns (bool) {
        if (_value > 0 && _value <= balanceOf[msg.sender]) {
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
            return true;
        }
        return false;
    }
    
    
    /// @notice
    /// @param address _from, address _to, uint _value
    /// @return bool
    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        if (allowance[_from][msg.sender] > 0 &&
            _value > 0 &&
            allowance[_from][msg.sender] >= _value && 
            balanceOf[_from] >= _value) {
            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
            allowance[_from][msg.sender] -= _value;
            return true;
        }
        return false;
    }
    
    /// @notice
    /// @param address _spender, uint _value
    /// @return bool
    function approve(address _spender, uint _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    /// @notice
    /// @param address _owner, address _spender
    /// @return uint
    function allowance(address _owner, address _spender) public constant returns (uint) {
        return allowance[_owner][_spender];
    }
}