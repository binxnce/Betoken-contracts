pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import './BetokenFund.sol';

/**
 * @title The ERC20 smart contract for the Kairo token in the Betoken fund.
 * @author Zefram Lou (Zebang Liu)
 */
contract ControlToken is MintableToken, PausableToken {
  using SafeMath for uint256;

  string public constant name = "Kairo";
  string public constant symbol = "KRO";
  uint8 public constant decimals = 18;

  event OwnerCollectFrom(address indexed _from, uint256 _value);

  /**
   * @notice Collects tokens from a user and sends them to the owner.
   * @param _from The address which you want to send tokens from
   * @param _value the amount of tokens to be transferred
   * @return true if succeeded, false otherwise
   */
  function ownerCollectFrom(address _from, uint256 _value) public onlyOwner returns(bool) {
    require(_from != address(0));

    // SafeMath.sub will throw if there is not enough balance.
    balances[_from] = balances[_from].sub(_value);
    balances[msg.sender] = balances[msg.sender].add(_value);
    OwnerCollectFrom(_from, _value);
    return true;
  }

  /**
   * @notice Burns the owner's entire token balance.
   * @return true if succeeded, false otherwise
   */
  function burnOwnerBalance() public onlyOwner returns(bool) {
    totalSupply_ = totalSupply_.sub(balances[owner]);
    delete balances[owner];
    return true;
  }

  /**
   * @notice Burns `_value / 1e8` Kairos from the owner's balance.
   * @return true if succeeded, false otherwise
   */
  function burnOwnerTokens(uint256 _value) public onlyOwner returns(bool) {
    // SafeMath.sub will throw if there is not enough balance.
    balances[owner] = balances[owner].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
  }

  function() public {
    revert();
  }
}
