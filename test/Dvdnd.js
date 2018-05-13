let Dvdnd = artifacts.require('Dvdnd')

const tokenName = "A Dividend-Paying Token"
const tokenSymbol = "DPT"
const tokenDecimals = 18;
const tokenSupply = 500;
const deploymentAddress = '0x627306090abab3a6e1400e9345bc60c78a8bef57'

contract('Dvdnd', (accounts) => {
    it('should deploy', () => {
        return Dvdnd.deployed().then((instance) => {
            assert.notEqual(instance, undefined || null || {})
        })
    })

    it('should have the defined name', () => {
        return Dvdnd.deployed()
        .then(instance => instance.name.call())
        .then(name => {
            assert.equal(name, tokenName)
        })
    })

    it('should have the defined symbol', () => {
        return Dvdnd.deployed()
        .then(instance => instance.symbol.call())
        .then(symbol => {
            assert.equal(symbol, tokenSymbol)
        })
    })

    it('should have the defined decimals', () => {
        return Dvdnd.deployed()
        .then(instance => instance.decimals.call())
        .then(decimals => {
            assert.equal(decimals, tokenDecimals)
        })
    })

    it('should have the defined supply', () => {
        return Dvdnd.deployed()
        .then(instance => instance.totalSupply.call())
        .then(supply => {
            assert.equal(supply, tokenSupply)
        })
    })

    it('should return the custodial address', () => {
        return Dvdnd.deployed()
        .then(instance => instance.custodian.call())
        .then(custodian => {
            assert.equal(custodian, deploymentAddress)
        })
    })

    it('should transfer custodial responsibility', () => {
        let originalCustodian
        let newCustodian
        return Dvdnd.deployed().then(instance => {
            return instance.custodian.call()
            .then((custodian) => {
                originalCustodian = custodian
                return instance.transferOwnership('0x0000000000000000000000000000000000000000')
            })
            .then(() => {
                return instance.custodian.call()
            })
            .then((custodian) => {
                newCustodian = custodian
            })
            .then(() => {
                assert.notEqual(originalCustodian, newCustodian)
            })
        })
    })
})