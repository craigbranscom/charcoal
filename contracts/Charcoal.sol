pragma solidity ^0.4.17;

//import "./ERC20.sol";

// @title Charcoal
// @author Stephen Craig Branscom
// @notice Contract for Charcoal, a loyalty points system for Tradeblazer
contract Charcoal {
    
    // @notice Final variables
    string public name;
    string public symbol;
    uint8 public decimals;
    address public contractAddress;
    address public owner;
    
    // @notice State variables
    uint256 public totalSupply;
    
    // @notice Balances of each account
    mapping (address => uint256) public balanceOf;
    
    // @notice List of accounts allowed to make a transfer to another account
    mapping (address => mapping (address => uint256)) public allowance;
    
    // @notice Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value);
    event Mint(address indexed from, uint256 value);
    
    // @notice Constructor
    // @dev 
    function Charcoal() public {
        name = "Charcoal";
        symbol = "CHAR";
        decimals = 0; // Testing changes to this for MetaMask Decimal issue
        contractAddress = this;
        owner = msg.sender;

        totalSupply = 12011;
        balanceOf[this] = 12000; // Give contract 12000 Charcoal
        balanceOf[msg.sender] = 11; // Give publishing account 11 Charcoal
    }
    
    // @notice Returns balance of Charcoal at given index
    // @param address _owner Address of owner's balance
    // @return uint256 Balance of Charcoal
    function balanceOf(address _owner) external view returns (uint256) {
        return balanceOf[_owner];
    }
    
    
    // @notice Transfers Charcoal from calling address to another user
    // @dev Transferring account param is passed implicitly
    // @param address _to, uint _value
    // @return bool True for success, or False for failure
    function transfer(address _to, uint _value) public returns (bool) {
        if (_value > 0 && _value <= balanceOf[msg.sender]) {
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
            return true;
        }
        return false;
    }
    
    // @notice Increases the total number of Charcoal in circulation
    // @dev Consider renaming to Mint()
    // @param uint256 _amount Amount added to total supply
    // @return bool True for success, or False for failure
    function increaseSupply(uint256 _amount) public returns (bool) {
        totalSupply += _amount;
        return true;
    }

    // @notice Decreases the total number of Charcoal in circulation
    // @dev Consider renaming to Burn()
    // @param uint256 _amount Amount removed from total supply
    // @return bool True for success, or False for failure
    function decreaseSupply(uint256 _amount) public returns (bool) {
        totalSupply -= _amount;
        return true;
    }
    
    // @notice Transfers an approved amount of Charcoal from one address to another
    // @dev Combine approve() + transferFrom() for contract payments
    // @param address _from Address to transfer from
    // @param address _to Address to transfer to
    // @param uint _value Value to transfer
    // @return bool True for success, or False for failure
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
    
    // @notice Approves spending of Charcoal by a third party
    // @dev _spender is the third party initiating transaction
    // @param address _spender Address of spending party
    // @param uint _value Value to approve for spending
    // @return bool success True for success, or False for failure
    function approve(address _spender, uint _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    // @notice Returns allowance at given indeces
    // @param address _owner Address of Charcoal owner
    // @param address _spender Address of Charcoal spender
    // @return uint Value of allowance
    function allowance(address _owner, address _spender) public constant returns (uint) {
        return allowance[_owner][_spender];
    }
}