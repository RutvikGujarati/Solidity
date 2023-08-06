const { Contract, ContractFactory } = require('fantomjs-contracts');

class SimpleContract extends Contract {
  constructor() {
    super();
    this.state.value = 0;
  }

  increment() {
    this.state.value += 1;
  }

  getValue() {
    return this.state.value;
  }
}

module.exports = ContractFactory.fromABI(SimpleContract);
