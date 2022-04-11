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
mati@hegemonek:~/Devel/crfa-block-checker$ bundle exec ruby crfa-block-checker.rb epochs/330p.json pool1d3gckjrphwytzw2uavgkxskwe08msumzsfj4lxnpcnpks3zjml3
Slots allocated: 39 for epochNo: 330
Checking slots...
Block minted on slot: 57483072 by pool leader: pool17jss6muzegagwnlju4t0mxsk875eu6r0uwr7mfamf2xcvrwk4tc due to a slot battle.
Block ghosted on slot: 57579392 due to a height battle.

----------------

Summary for epochNo: 330
Scheduled to mint blocks: 39
Minted blocks: 38
Performance: 97.43589743589743 %
----------------
Height Battle Lost Count: 1
Slot Battle Lost Count: 1
Height Battle Lost Percentage: 2.564102564102564 %
Slot Battle Lost Percentage: 2.564102564102564 %
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
