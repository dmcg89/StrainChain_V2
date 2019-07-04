const Token = artifacts.require('./Token.sol');
const _ = '        ';

contract('Token', async function (accounts) {
  console.log(accounts)
  let token;

  before(done => {
    (async () => {
      try {
        // TODO: All setup steps belong here, including contract deployment.
        token = await Token.new();
        var tx = await web3.eth.getTransactionReceipt(token.transactionHash);
        totalGas = totalGas.plus(tx.gasUsed);
        console.log(_ + tx.gasUsed + ' - Deploy Token');
        token = await Token.deployed();

        // Output how much gas was spent
        console.log(_ + '-----------------------');
        console.log(_ + totalGas.toFormat(0) + ' - Total Gas');
        done();
      }
      catch (error) {
        console.error(error);
        done(false);
      }
    })();
  });

  describe('Token.sol', function () {
    it('Should always pass this canary test', async () => {
      assert(true === true, 'this is true');
    });

    it('Should make first account an owner', async () => {
      // TODO:
      // What does deployed() do?
      // Where is from?
      // ***
      // NOTE:
      // creates instance
      // creator owns the instance (me)
      let instance = await Token.deployed();
      let owner = await instance.owner();
      assert.equal(owner, accounts[0]);
    });

    it('Should start with no existing tokens', async () => {
      let instance = await Token.deployed();
      // Begin with zero balance
      let zeroBalance = await instance.totalSupply();
      assert(
        // TODO:
        // What is toString()?
        // Why does it take in a parameter of 10?
        // ***
        // NOTE:
        // its converting to base 10.
        zeroBalance.toString(10) === '0',
        'Contract should have no tokens at this point'
      )
    });

    it('Should issue 1 tokin token', async () => {
      let instance = await Token.deployed();
      // Try minting (baking) a new token
      try {
        // heres your owner address
        const instance = await Token.deployed();
        const owner = await instance.owner();
        const address = owner;

        // make a bread to get its tokenId
        const tokenId = '';
        await instance.mint(address, tokenId);
        // TODO:
        // What parameters would this take?
        // Where do they come from?
      } catch (error) {
        console.log(error);
        assert(false, error);
      }

      // Ensure totalSupply is increased to 1
      let totalSupply = await instance.totalSupply();
      assert(
        totalSupply.toString(10) === '1',
        'Contract should have balance of 1 instead it has: ' + totalSupply.toString(10)
      );

      // Make sure the token at index 0 has id 1
      let tokenId = await instance.tokenOfOwnerByIndex(accounts[0], '0');
      assert(
        tokenId.toString(10) === '1',
        'Token at index 0 is ' + tokenId.toString(10) // TODO: why 10?
      )
    });

    it("Should mint an item to the owner only", async () => {
      let instance = await Token.deployed();
      let other = accounts[1];
      const address = '';
      const tokenId = '';

      await instance.transferOwnership(other);
      await assertRevert(instance.mint(address, tokenId));
    });