pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Factory.sol";
import "./Token.sol";
import "./TokenLootBox.sol";
import "./Strings.sol";

contract TokenFactory is Factory, Ownable {
  using Strings for string;

  address public proxyRegistryAddress;
  address public nftAddress;
  address public lootBoxNftAddress;
  string public baseURI = "https://opensea-Tokens-api.herokuapp.com/api/factory/";

  /**
   * Enforce the existence of only 100 OpenSea Tokens.
   */
  uint256 Token_SUPPLY = 100;

  /**
   * Three different options for minting Tokens (basic, premium, and gold).
   */
  uint256 NUM_OPTIONS = 3;
  uint256 SINGLE_Token_OPTION = 0;
  uint256 MULTIPLE_Token_OPTION = 1;
  uint256 LOOTBOX_OPTION = 2;
  uint256 NUM_TokenS_IN_MULTIPLE_Token_OPTION = 4;

  constructor(address _proxyRegistryAddress, address _nftAddress) public {
    proxyRegistryAddress = _proxyRegistryAddress;
    nftAddress = _nftAddress;
    lootBoxNftAddress = address(new TokenLootBox(_proxyRegistryAddress, address(this)));
  }

  function name() external view returns (string memory) {
    return "OpenSeaToken Item Sale";
  }

  function symbol() external view returns (string memory) {
    return "CPF";
  }

  function supportsFactoryInterface() public view returns (bool) {
    return true;
  }

  function numOptions() public view returns (uint256) {
    return NUM_OPTIONS;
  }
  
  function mint(uint256 _optionId, address _toAddress) public {
    // Must be sent from the owner proxy or owner.
    ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    assert(address(proxyRegistry.proxies(owner())) == msg.sender || owner() == msg.sender || msg.sender == lootBoxNftAddress);
    require(canMint(_optionId));

    Token openSeaToken = Token(nftAddress);
    if (_optionId == SINGLE_Token_OPTION) {
      openSeaToken.mintTo(_toAddress);
    } else if (_optionId == MULTIPLE_Token_OPTION) {
      for (uint256 i = 0; i < NUM_TokenS_IN_MULTIPLE_Token_OPTION; i++) {
        openSeaToken.mintTo(_toAddress);
      }
    } else if (_optionId == LOOTBOX_OPTION) {
      TokenLootBox openSeaTokenLootBox = TokenLootBox(lootBoxNftAddress);
      openSeaTokenLootBox.mintTo(_toAddress);
    } 
  }

  function canMint(uint256 _optionId) public view returns (bool) {
    if (_optionId >= NUM_OPTIONS) {
      return false;
    }

    Token openSeaToken = Token(nftAddress);
    uint256 TokenSupply = openSeaToken.totalSupply();

    uint256 numItemsAllocated = 0;
    if (_optionId == SINGLE_Token_OPTION) {
      numItemsAllocated = 1;
    } else if (_optionId == MULTIPLE_Token_OPTION) {
      numItemsAllocated = NUM_TokenS_IN_MULTIPLE_Token_OPTION;
    } else if (_optionId == LOOTBOX_OPTION) {
      TokenLootBox openSeaTokenLootBox = TokenLootBox(lootBoxNftAddress);
      numItemsAllocated = openSeaTokenLootBox.itemsPerLootbox();
    }
    return TokenSupply < (Token_SUPPLY - numItemsAllocated);
  }
  
  function tokenURI(uint256 _optionId) external view returns (string memory) {
    return Strings.strConcat(
        baseURI,
        Strings.uint2str(_optionId)
    );
  }

  /**
   * Hack to get things to work automatically on OpenSea.
   * Use transferFrom so the frontend doesn't have to worry about different method names.
   */
  function transferFrom(address _from, address _to, uint256 _tokenId) public {
    mint(_tokenId, _to);
  }

  /**
   * Hack to get things to work automatically on OpenSea.
   * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
   */
  function isApprovedForAll(
    address _owner,
    address _operator
  )
    public
    view
    returns (bool)
  {
    if (owner() == _owner && _owner == _operator) {
      return true;
    }

    ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    if (owner() == _owner && address(proxyRegistry.proxies(_owner)) == _operator) {
      return true;
    }

    return false;
  }

  /**
   * Hack to get things to work automatically on OpenSea.
   * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
   */
  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return owner();
  }
}