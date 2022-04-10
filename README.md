# Introduction

Checks if blocks have been lost due to slot battle or height battle

# Install
```bash
apt get install ruby ruby-bundler

bundle install --path vendor/bundle
```

# Run
```bash
bundler exec ruby crfa-block-checker.rb epochs/330.json
```

# Example run
```bash
mati@hegemonek:~/Devel/crfa-block-checker$ bundle exec ruby crfa-block-checker.rb epochs/329p.json
Slots allocated: 46 for epochNo: 329
Checking...
HEIGHT_BATTLE -> block ghosted on slot: 57064735
SLOT_BATTLE -> block minted on slot: 57089597 by pool leader: pool1vdh6kxcqt9mxavyv80ggnec6jjwms44ms30rhle3lt266aj8jgh
HEIGHT_BATTLE -> block ghosted on slot: 57189016
----------------
----------------
Summary for epochNo: 329
Height Battle Lost Count: 2
Slot Battle Lost Count: 1
Height Battle Lost Percentage: 4.3478260869565215 %
Slot Battle Lost Percentage: 2.1739130434782608 %
```

# KNOWN ISSUES
- cncli produces leaderschedule but for now we have to manully skip a few lines from the generated epoch file

# TODO
- cardano-cli format support
- testing
- poolid configurable in the command line?

