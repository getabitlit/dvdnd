let Dvdnd = artifacts.require('Dvdnd')

contract('Dvdnd', (accounts) => {
    it('should deploy', () => {
        return Dvdnd.deployed().then((instance) => {
            return instance
        })
    })
})