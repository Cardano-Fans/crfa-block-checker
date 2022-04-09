# Introduction

Checks if blocks have been lost due to slot battle or height battle

# Install
```
apt get install ruby ruby-bundler

bundle install --path vendor/bundle
```

# Run
```
bundler exec ruby crfa-block-checker.rb epochs/330.json
```

# KNOWN ISSUES
- cncli produces leaderschedule but for now we have to manully skip a few lines from the generated epoch file

# TODO
- epoch level statistics
- testing