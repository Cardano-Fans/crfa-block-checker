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
mati@hegemonek:~/Devel/crfa-block-checker$ bundle exec ruby crfa-block-checker.rb epochs/326p.json pool1d3gckjrphwytzw2uavgkxskwe08msumzsfj4lxnpcnpks3zjml3

Slots allocated: 33 for epochNo: 326
Checking slots...
Block ghosted on slot: 55606470 due to a height battle.
Block minted on slot: 55661370 by pool leader: pool189j5mz6wa0gfrakwvn2tar7qt309qxrmsgde5v6qwm892n6re3v due to a slot battle.
Block minted on slot: 55719658 by pool leader: pool1cx79cuquzjdm0c6xk3ace333zcq83v44p68vx7edpfufzkp8m35 due to a slot battle.
Block ghosted on slot: 55814442 due to a height battle.
----------------
----------------
Summary for epochNo: 326
Height Battle Lost Count: 2
Slot Battle Lost Count: 2
Height Battle Lost Percentage: 6.0606060606060606 %
Slot Battle Lost Percentage: 6.0606060606060606 %
```

# Known issues
- cncli produces a leader schedule but for now we have to manully skip a few lines from the generated epoch file.

Example command to skip headers (5 lines):
```
tail -n +5 320.json > 320p.json
```

# Recommendations
If you notice many lost height battles you can do something about it. While you don't have any control over slot battles, you have *some* control over height battles. My recommendation is to launch more relay nodes in other parts of the world, e.g. US EAST coast. If you cannot launch more relay nodes than shut down one relay node in one location and spin up in another one.
To some extend a small ca 5 or 6% of height battles (ghosted blocks) is currently expected (April 2022). Once P2P (Peer to Peer) rolls our on Cardano things should get considerably better. This is due to the fact that there will be much more optimised algorithm to propogate blocks from the pool and propagate blocks minted by your pool.

# TODO
- cardano-cli format support in addition to Andrew Westberg's cncli's format

# Support / Donation
If you find this tool useful, you can donate any amount in ADA to the following Cardano address:
addr1qy05muetmauqfs992qd74scaeqzejjntaass68tyecfx247zddeldn7syvs5x2uvuefk66azhr7lelrj423lxapuxkks90meng
