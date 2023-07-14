## Introduction

The script reads leaderlogs for an epoch and generates a report including minted blocks, lost blocks due to slot battles, height battles and provides performance statistics.

## Features

* Simple plain text report in the terminal
* Markdown report to Discord server
* Markdown report to Telegram Group
* Leader schedule saved from `cncli leaderlogs` output
* Leader schedule saved from `cardano-cli query leadership-schedule` output

## Installation

```
apt get install ruby ruby-bundler
git clone https://github.com/Cardano-Fans/crfa-block-checker
cd crfa-block-checker
bundle install
cp .env.example .env
```

Now replace the values in `.env` with your own values.

## Usage

### Check blocks using latest leader schedule

```
script/report-blocks stdout
```

### Check blocks for specific epoch

by passing the epoch number (name of the leader-schedule file)

```
script/report-blocks stdout --epoch=416
```

### Check blocks for another pool

passing pool-id takes precedence over the `POOL_ID` env variable.

```
script/report-blocks stdout --pool-id=pool1cpr59c88ps8499gtgegr3muhclr7dln35g9a3rqmv4dkxg9n3h8
```

### Report to Discord

In Discord `Edit Channel -> Integrations -> Webhooks` you'll need to create a new webhook and use the URL for the env variable `DISCORD_WEBHOOK_URL` in your `.env` file.

Then you can run `script/report-blocks discord` the same way as described above.

### Report to Telegram

Setup a Telegram Bot using [BotFather](https://t.me/botfather) to obtain the required API token and get the Chat-ID of your Group by inviting @RawDataBot into your Group. Store both values in `.env`.

Then you can run `script/report-blocks telegram` the same way as described above.

## Examples

```
$ script/report-blocks stdout -e 416

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

## Support / Donation
If you find this tool useful, you can donate any amount in ADA to the following Cardano address:
```
addr1qy05muetmauqfs992qd74scaeqzejjntaass68tyecfx247zddeldn7syvs5x2uvuefk66azhr7lelrj423lxapuxkks90meng
```
