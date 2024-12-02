// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract iTamCoin is ERC20 {
    using SafeMath for uint256;
    address public owner;
    uint256 public constant MAX_SUPPLY = 100000; // Max supply set to 100000
    uint256 public mintedAmount;
    uint256 private counter = 1; // Counter to simulate randomness

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner is allowed to initiate this function");
        _;
    }

    modifier validateMint(uint256 value) {
        require(totalSupply() + value <= MAX_SUPPLY, "Exceeds maximum supply");
        _;
    }

    constructor(uint256 initialSupply) ERC20("iTamCoin", "ITC") {
        _mint(msg.sender, initialSupply);
        owner = msg.sender;
        counter = 1; // Initialize counter
    }

    function mint(address to, uint256 value) external onlyOwner validateMint(value) {
        _mint(to, value);
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function burn(address from, uint256 value) external {
        _burn(from, value);
    }

    function flipCoin() external onlyOwner validateMint(mintedAmount){
        require(mintedAmount == 0, "Minted amount already assigned, transfer it first");

        // Simulate coin flip using counter
        uint256 randomValue = (counter % 10) + 1;
        counter++;

        bool coinFlipResult = (randomValue > 5);

        if (coinFlipResult) {
            // Assign a random amount to be minted (from 1 to 10 for example)
            mintedAmount = randomValue;
        } else {
            mintedAmount = 0;
        }
    }

    function transferMintedCoin(address to) external onlyOwner validateMint(mintedAmount) {
        require(mintedAmount > 0, "No minted amount to transfer, flip the coin first");
        _mint(to, mintedAmount);
        mintedAmount = 0;
    }
}
