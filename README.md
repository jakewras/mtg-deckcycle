# mtg-deckcycle

Ruby script used to login to [Tappedout.net](http://tappedout.net/) and deckcycle a Magic the Gathering deck every three hours between the hours of 9 am and 10 pm.

## Requirements
- Firefox web browser
- geckodriver loaded in path:
    https://github.com/mozilla/geckodriver/releases
- Ruby

## Installation
2023 macOS 13.4

1. `brew install rbenv`
2. `rbenv init`
3. `rbenv install –list`
4. `rbenv install 3.2.2`
5. `rbenv global 3.2.2`
6. `brew install geckodriver`
7. `brew install --cask firefox`
8. `rm Gemfile.lock`
9. `rbenv exec gem install bundler`
10. `rbenv exec bundle install`

## Usage
```
Usage: deckcycle.rb [options]
    -n, --name [NAME]                Name of deck to deckcycle
    -u, --username [USERNAME]        Tappedout.net username
    -p, --password [PASSWORD]        Tappedout.net password
```
`Example: rbenv exec ruby deckcycle.rb -n '<deckname>' -u '<username>' -p '<password>'`
