## Introduction

Checks if blocks have been lost due to slot battles or height battles and provides statistics.

Supporting files saved from `cncli leaderlogs` or `cardano-cli query leadership-schedule` and dropped into the `./epochs` folder.

## Installation

```
apt get install ruby ruby-bundler
git clone https://github.com/Cardano-Fans/crfa-block-checker
cd crfa-block-checker
bundle install
cp .env.example .env
```

Now replace the values in .env with your values.

## Usage

### Check blocks for current epoch

```
bundle exec ruby run.rb
```

### Check blocks for specific epoch

passing the path to the leader-schedule file as the second argument takes precedence over the env variable.

```
bundle exec ruby run.rb <path_to_leader_schedule>
```

### Check blocks for another pool

passing the pool-id as the second argument takes preference over the env variable.

```
bundle exec ruby run.rb <path_to_leader_schedule> <pool_id>
```

## Example run
```
$ bundle exec ruby run.rb ./epochs/416.json

EPOCH 416 SUMMARY
----------------------
Assigned slots to mint blocks: 14
Minted blocks: 12
Lost height battles: 1
Lost slot battles: 1


LOST SLOT BATTLES
----------------------
- Block minted on slot 94419032 by pool pool1yl9plldxt500xfkfu6n3wggvnzcs5rshjyxq4dkea6m0kt7qg9v at 2023-06-05 17:15:23 UTC


LOST HEIGHT BATTLES
----------------------
- Block ghosted on slot 94348935 at 2023-06-04 21:47:06 UTC


PERFORMANCE STATS
----------------------
Minted blocks: 85.71%
Lost height battles: 7.14%
Lost slot battles: 7.14%



Cardano Block Checker
Copyright Cardano Fans (CRFA) (https://cardano.fans)
```

## Recommendations
If you notice many lost height battles you can do something about it. While you don't have any control over slot battles, you have *some* control over height battles. My recommendation is to launch more relay nodes in other parts of the world, e.g. US EAST coast. If you cannot launch more relay nodes than shut down one relay node in one location and spin up in another one.

To some extend a small percentage (1%) of height battles (ghosted blocks) is currently expected. Once P2P (Peer to Peer) rolls our on Cardano things should get considerably better. This is due to the fact that there will be much more optimised algorithm to propogate blocks from the pool and propagate blocks minted by your pool.

## TODO
- cardano-cli format support in addition to Andrew Westberg's cncli's format

## Support / Donation
If you find this tool useful, you can donate any amount in ADA to the following Cardano address:
```
addr1qy05muetmauqfs992qd74scaeqzejjntaass68tyecfx247zddeldn7syvs5x2uvuefk66azhr7lelrj423lxapuxkks90meng
```
