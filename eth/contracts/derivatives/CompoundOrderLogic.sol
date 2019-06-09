pragma solidity 0.5.8;

import "./CompoundOrderStorage.sol";
import "../interfaces/CEther.sol";
import "../Utils.sol";

contract CompoundOrderLogic is CompoundOrderStorage, Utils(address(0), address(0)) {
  function executeOrder(uint256 _minPrice, uint256 _maxPrice) public {
    buyTime = now;
  }

  function sellOrder(uint256 _minPrice, uint256 _maxPrice) public returns (uint256 _inputAmount, uint256 _outputAmount);

  function repayLoan(uint256 _repayAmountInDAI) public;

  function getCurrentLiquidityInDAI() public view returns (bool _isNegative, uint256 _amount);
  
  function getCurrentCollateralRatioInDAI() public view returns (uint256 _amount);

  function getCurrentProfitInDAI() public view returns (bool _isNegative, uint256 _amount);

  function getMarketCollateralFactor() public view returns (uint256);

  function __sellDAIForToken(uint256 _daiAmount) internal returns (uint256 _actualDAIAmount, uint256 _actualTokenAmount) {
    ERC20Detailed t = __underlyingToken(compoundTokenAddr);
    (,, _actualTokenAmount, _actualDAIAmount) = __kyberTrade(dai, _daiAmount, t); // Sell DAI for tokens on Kyber
    require(_actualDAIAmount > 0 && _actualTokenAmount > 0); // Validate return values
  }

  function __sellTokenForDAI(uint256 _tokenAmount) internal returns (uint256 _actualDAIAmount, uint256 _actualTokenAmount) {
    ERC20Detailed t = __underlyingToken(compoundTokenAddr);
    (,, _actualDAIAmount, _actualTokenAmount) = __kyberTrade(t, _tokenAmount, dai); // Sell tokens for DAI on Kyber
    require(_actualDAIAmount > 0 && _actualTokenAmount > 0); // Validate return values
  }

  // Convert a DAI amount to the amount of a given token that's of equal value
  function __daiToToken(address _cToken, uint256 _daiAmount) internal view returns (uint256) {
    if (_cToken == CETH_ADDR) {
      // token is ETH
      return _daiAmount.mul(ORACLE.assetPrices(DAI_ADDR)).div(PRECISION);
    }
    ERC20Detailed t = __underlyingToken(_cToken);
    return _daiAmount.mul(ORACLE.assetPrices(DAI_ADDR)).mul(10 ** getDecimals(t)).div(ORACLE.assetPrices(address(t)).mul(PRECISION));
  }

  // Convert a compound token amount to the amount of DAI that's of equal value
  function __tokenToDAI(address _cToken, uint256 _tokenAmount) internal view returns (uint256) {
    if (_cToken == CETH_ADDR) {
      // token is ETH
      return _tokenAmount.mul(PRECISION).div(ORACLE.assetPrices(DAI_ADDR));
    }
    ERC20Detailed t = __underlyingToken(_cToken);
    return _tokenAmount.mul(ORACLE.assetPrices(address(t))).mul(PRECISION).div(ORACLE.assetPrices(DAI_ADDR).mul(10 ** uint256(t.decimals())));
  }

  function __underlyingToken(address _cToken) internal view returns (ERC20Detailed) {
    if (_cToken == CETH_ADDR) {
      // ETH
      return ETH_TOKEN_ADDRESS;
    }
    CERC20 ct = CERC20(_cToken);
    address underlyingToken = ct.underlying();
    ERC20Detailed t = ERC20Detailed(underlyingToken);
    return t;
  }
}