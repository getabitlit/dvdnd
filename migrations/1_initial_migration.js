let Migrations = artifacts.require('./Migrations.sol')
let Dvdnd      = artifacts.require('./Dvdnd.sol')

module.exports = (deployer) => {
  deployer.deploy(Migrations)
  deployer.deploy(Dvdnd)
}
