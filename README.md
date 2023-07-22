## Introduction

The script reads leaderlogs for an epoch and generates a report including minted blocks, lost blocks due to slot battles, height battles and provides performance statistics.

## Features

* Simple plain text report to stdout (default)
* Markdown report to Discord server
* Markdown report to Telegram Group
* Simple and short plain text report to Twitter
* Leader schedule saved from `cncli leaderlogs` or `cardano-cli query leadership-schedule` output

## Installation & Setup

### Docker

```
docker pull lacepool/cardano-block-checker
```

### Local

```
apt get install ruby ruby-bundler
git clone https://github.com/Cardano-Fans/crfa-block-checker
cd crfa-block-checker
bundle install
```

Copy `.env.example` and replace the values needed depending on the reporters you want to use.

```
cp .env.example .env
```

## Usage

Drop a leader schedule file from cncli or cardano-cli in the `./epochs` folder and make sure to name the file after the epoch number (e.g. `416.json` or `416.txt`).

### Check blocks using latest leader schedule file

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

### Report to Twitter

First you need to set up a twitter developer app and grant rights for tweeting from your twitter account. This is required only once (one-off task).

1. Sign in to Twitter's developer portal at https://developer.twitter.com
2. Create a new project and app
3. Store the OAuth 2.0 Client ID and Client Secret as `TWITTER_CLIENT_ID` and `TWITTER_CLIENT_SECRET` in your `.env` file
4. Run `bundle exec ruby twitter/authorize_oneoff.rb`. It prints a link and prompts you to enter a code. When opening the link you’ll want your browser to be already authenticated into your twitter account.
5. Click authorize and wait for being redirected.
6. Copy the `code` query string parameter value from the URL
7. Paste the code into your shell

Now you're all set. Run `script/report-blocks twitter --epoch 416` for tweeting a summary and performance report from your twitter account.

### With Docker

Report to stdout

```
docker run --rm \
        -v /path/to/leaderlogs:/block-checker/epochs \
        -e BLOCKFROST_MAINNET_KEY=xxx \
        lacepool/cardano-block-checker:latest stdout --epoch 416 --pool-id pool1cpr59c88ps8499gtgegr3muhclr7dln35g9a3rqmv4dkxg9n3h8
```

Report to Discord

```
docker run --rm \
        -v /path/to/leaderlogs:/block-checker/epochs \
        -e BLOCKFROST_MAINNET_KEY=xxx \
        -e DISCORDISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/... \
        lacepool/cardano-block-checker:latest discord --epoch 416 --pool-id pool1cpr59c88ps8499gtgegr3muhclr7dln35g9a3rqmv4dkxg9n3h8
```

Report to Telegram

```
docker run --rm \
        -v /path/to/leaderlogs:/block-checker/epochs \
        -e BLOCKFROST_MAINNET_KEY=xxx \
        -e TELEGRAM_API_TOKEN=xxx \
        -e TELEGRAM_CHAT_ID=-1234 \
        lacepool/cardano-block-checker:latest telegram --epoch 416 --pool-id pool1cpr59c88ps8499gtgegr3muhclr7dln35g9a3rqmv4dkxg9n3h8
```

Report to Twitter

Follow the twitter set up instructions #1 and #2. Then you start the container and expose ClientID and ClientSecret and overwrite the entrypoint to enter a shell. Inside the container you continue the instructions from #4. To not add a database dependency the twitter auth credentials are stored in the file system. Therefore, you need to mount a volume to persist marshalled objects of the oauth client and the twitter token response. It can be any folder on your local machine. See the following example.

```
docker run -it \
    -v /path/to/twitter/dumps:/block-checker/helpers/twitter/dumps \
    -e TWITTER_CLIENT_ID=xxx \
    -e TWITTER_CLIENT_SECRET=xxx \
    --entrypoint /bin/sh \
    lacepool/cardano-block-checker:latest
```

Once you finished the authorization process you can tweet your block report using docker

```
docker run --rm \
    -v /path/to/leaderlogs:/block-checker/epochs \
    -v /path/to/twitter/dumps:/block-checker/helpers/twitter/dumps \
    -e BLOCKFROST_MAINNET_KEY=xxx \
    lacepool/cardano-block-checker:latest twitter -e 416 --pool-id pool1cpr59c88ps8499gtgegr3muhclr7dln35g9a3rqmv4dkxg9n3h8
```

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
