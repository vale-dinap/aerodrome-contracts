# Aerodrome Finance (Constant Product) – Compatibility Layer

## Overview
This repository contains a fork of the [Aerodrome Contracts](https://github.com/aerodrome-finance/contracts) protocol, designed to ensure compatibility with the latest Solidity versions. The primary focus of this fork is to facilitate interaction and integration testing with external smart contracts, while avoiding any modifications to the core logic of Aerodrome, aside from necessary adjustments for Solidity compiler compatibility.

## Purpose
This compatibility layer has been created with two goals in mind:
- **Ensure Compatibility**: Update the Aerodrome Contracts to work seamlessly with Solidity 0.8.x and newer versions, ensuring that external projects do not face version incompatibility issues.
- **Enable Testing**: Provide an environment where developers can test their smart contracts against the Aerodrome protocol, using modern Solidity tooling, without needing to modify the protocol's fundamental behavior.

## What’s Included
The repository includes:
- All the smart contracts and libraries originally included in Aerodrome.
- Updates for compatibility with Solidity 0.8.x and above.
- Optimized stack usage to prevent errors at compile time. This required substantial refactoring of some parts of the codebase.
- Minor gas optimizations.

## What’s Not Changed
To maintain the integrity of the original protocol:
- No changes have been made to the core logic or functionality of Aerodrome Contracts, except for those required to ensure compatibility with newer Solidity compiler versions and prevent compiler errors.
- The operational and fee structures remain the same as in the original Aerodrome Contracts.

## Directory Structure
A high-level overview of the project structure (Solidity files only):

🔷 Blue diamond: Contracts and libraries

🔶 Orange diamond: Interfaces
```bash
📦contracts
┣ 📂art
┃ ┣ 🔷BokkyPooBahsDateTimeLibrary.sol
┃ ┣ 🔷PerlinNoise.sol
┃ ┗ 🔷Trig.sol
┣ 📂factories
┃ ┣ 🔷FactoryRegistry.sol
┃ ┣ 🔷GaugeFactory.sol
┃ ┣ 🔷ManagedRewardsFactory.sol
┃ ┣ 🔷PoolFactory.sol
┃ ┗ 🔷VotingRewardsFactory.sol
┣ 📂gauges
┃ ┗ 🔷Gauge.sol
┣ 📂governance
┃ ┣ 🔷GovernorCountingMajority.sol
┃ ┣ 🔷GovernorSimple.sol
┃ ┣ 🔷GovernorSimpleVotes.sol
┃ ┣ 🔶IGovernor.sol
┃ ┣ 🔶IVetoGovernor.sol
┃ ┣ 🔶IVotes.sol
┃ ┣ 🔷VetoGovernor.sol
┃ ┣ 🔷VetoGovernorCountingSimple.sol
┃ ┣ 🔷VetoGovernorVotes.sol
┃ ┗ 🔷VetoGovernorVotesQuorumFraction.sol
┣ 📂interfaces
┃ ┣ 📂factories
┃ ┃ ┣ 🔶IFactoryRegistry.sol
┃ ┃ ┣ 🔶IGaugeFactory.sol
┃ ┃ ┣ 🔶IManagedRewardsFactory.sol
┃ ┃ ┣ 🔶IPoolFactory.sol
┃ ┃ ┗ 🔶IVotingRewardsFactory.sol
┃ ┣ 🔶IAero.sol
┃ ┣ 🔶IAirdropDistributor.sol
┃ ┣ 🔶IEpochGovernor.sol
┃ ┣ 🔶IGauge.sol
┃ ┣ 🔶IMinter.sol
┃ ┣ 🔶IPool.sol
┃ ┣ 🔶IPoolCallee.sol
┃ ┣ 🔶IReward.sol
┃ ┣ 🔶IRewardsDistributor.sol
┃ ┣ 🔶IRouter.sol
┃ ┣ 🔶IVeArtProxy.sol
┃ ┣ 🔶IVoter.sol
┃ ┣ 🔶IVotingEscrow.sol
┃ ┗ 🔶IWETH.sol
┣ 📂libraries
┃ ┣ 🔷BalanceLogicLibrary.sol
┃ ┣ 🔷DelegationLogicLibrary.sol
┃ ┣ 🔷ProtocolTimeLibrary.sol
┃ ┗ 🔷SafeCastLibrary.sol
┣ 📂rewards
┃ ┣ 🔷BribeVotingReward.sol
┃ ┣ 🔷FeesVotingReward.sol
┃ ┣ 🔷FreeManagedReward.sol
┃ ┣ 🔷LockedManagedReward.sol
┃ ┣ 🔷ManagedReward.sol
┃ ┣ 🔷Reward.sol
┃ ┗ 🔷VotingReward.sol
┣ 🔷Aero.sol
┣ 🔷AirdropDistributor.sol
┣ 🔷EpochGovernor.sol
┣ 🔷Minter.sol
┣ 🔷Pool.sol
┣ 🔷PoolFees.sol
┣ 🔷ProtocolForwarder.sol
┣ 🔷ProtocolGovernor.sol
┣ 🔷RewardsDistributor.sol
┣ 🔷Router.sol
┣ 🔷VeArtProxy.sol
┣ 🔷Voter.sol
┗ 🔷VotingEscrow.sol
```

## Installation
To use this compatibility layer for testing or integrating external projects:

### 1. Clone the Repository:
```bash
git clone https://github.com/vale-dinap/aerodrome-contracts.git
```

### 2. Install Dependencies:
Make sure you have installed the necessary dependencies by running:
```bash
yarn install
```

### 3. Compile Contracts:
Ensure the Solidity compiler version is compatible with the updated contracts:
```bash
forge build
```

### 4. Run Tests:
Test the contracts using Foundry or your preferred testing framework:
```bash
forge test
```

## Contributing
Contributions are welcome, especially those that improve compatibility or testing capabilities. Please open an issue or a pull request if you encounter bugs or have suggestions for improvements.

## License
This project is licensed under the same terms as the original Aerodrome Contracts. All rights to the original Aerodrome Contracts code remain with [Aerodrome Finance](https://aerodrome.finance/).