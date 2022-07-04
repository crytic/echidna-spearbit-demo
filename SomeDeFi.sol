pragma solidity ^0.8.1;

// This is code from OpenZeppelin to simulate ERC20 tokens
contract ERC20 {
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    constructor(uint256 minted) {
        _mint(msg.sender, minted);
    }

    function totalSupply() public view virtual returns (uint256) { return _totalSupply; }
    function balanceOf(address account) public view virtual returns (uint256) { return _balances[account]; }
    function transfer(address to, uint256 amount) public virtual returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }
}

contract SomeDefi is ERC20 {
  ERC20 public token;

  constructor() public ERC20(0) {}

  function mintShares(uint256 tokens) public {
      token.transferFrom(msg.sender, address(this), tokens); 
      if (totalSupply() == 0)
          _mint(msg.sender, tokens);
      else
          _mint(msg.sender, 10 ** 18 * tokens / totalSupply()); 
  }

  function withdrawShares(uint256 shares) public {
      require(sharesOf(msg.sender) >= shares);
      uint256 oldTotalSupply = totalSupply();
      _burn(msg.sender, shares);

      if (oldTotalSupply == shares)
          token.transfer(msg.sender, shares);
      else
          token.transfer(msg.sender, shares * totalSupply() / 10 ** 18);
  }

  function sharesOf(address user) public returns (uint256) {
      return balanceOf(user); 
  }
}

contract TestSomeDefi is SomeDefi {
  constructor() public {
      token = new ERC20(type(uint256).max);
      token.transfer(address(0x10000), type(uint256).max / 2);
      token.transfer(address(0x20000), type(uint256).max / 2);
  }

  function testMintShares() public {
      require(totalSupply() == 0);
      uint256 oldBalance = token.balanceOf(msg.sender);
      assert(oldBalance >= 1000);
      mintShares(1000);
      assert(sharesOf(msg.sender) == 1000);
      assert(token.balanceOf(msg.sender) == oldBalance - 1000);
  }

  function testWithdrawShares() public {
      require(totalSupply() == 0);
      uint256 oldBalance = token.balanceOf(msg.sender);
      assert(oldBalance >= 1000);
      mintShares(1000);
      assert(sharesOf(msg.sender) == 1000);
      assert(token.balanceOf(msg.sender) == oldBalance - 1000);
      withdrawShares(1000);
      assert(token.balanceOf(msg.sender) == oldBalance);
  }
}

