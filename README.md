## Introduction

Checks if blocks have been lost due to slot battles or height battles and provides statistics.

## Installation
```
apt get install ruby ruby-bundler
git clone https://github.com/Cardano-Fans/crfa-block-checker
cd crfa-block-checker
bundle install --path vendor/bundle
```

## Usage
```
bundle exec ruby crfa-block-checker.rb <path_to_leader_schedule> <pool_id>
```

## Example run
```
export BLOCKFROST_MAINNET_KEY=mainnetS6e1C6yuxQNHOX8SwVNHPvomtpxxxxxxx

mati@hegemonek:~/Devel/crfa-block-checker$ bundle exec ruby crfa-block-checker.rb epochs/332p.json pool1d3gckjrphwytzw2uavgkxskwe08msumzsfj4lxnpcnpks3zjml3
Cardano Block Checker
Copyright Cardano Fans (CRFA)
Latest slot:58552780
Slots allocated: 51 for epochNo: 332
Checking if slots filled by blocks...
Block ghosted on slot: 58075883 due to a height battle at 2022-04-11T03:56:14+02:00.
Block ghosted on slot: 58341106 due to a height battle at 2022-04-14T05:36:37+02:00.
Block ghosted on slot: 58463894 due to a height battle at 2022-04-15T15:43:05+02:00.

----------------

Summary for epochNo: 332
Scheduled to mint blocks: 51
Minted blocks: 48
Height Battle Lost Count: 3
Slot Battle Lost Count: 0
----------------
Epoch 332 already finished, showing full performance stats:
Performance: 94.11764705882352 %
Height Battle Lost Percentage: 5.88235294117647 %
Slot Battle Lost Percentage: 0.0 %
```

## Recommendations
If you notice many lost height battles you can do something about it. While you don't have any control over slot battles, you have *some* control over height battles. My recommendation is to launch more relay nodes in other parts of the world, e.g. US EAST coast. If you cannot launch more relay nodes than shut down one relay node in one location and spin up in another one.
To some extend a small ca 5 or 6% of height battles (ghosted blocks) is currently expected (April 2022). Once P2P (Peer to Peer) rolls our on Cardano things should get considerably better. This is due to the fact that there will be much more optimised algorithm to propogate blocks from the pool and propagate blocks minted by your pool.

## TODO
- cardano-cli format support in addition to Andrew Westberg's cncli's format

## Support / Donation
If you find this tool useful, you can donate any amount in ADA to the following Cardano address:
```
addr1qy05muetmauqfs992qd74scaeqzejjntaass68tyecfx247zddeldn7syvs5x2uvuefk66azhr7lelrj423lxapuxkks90meng
```
