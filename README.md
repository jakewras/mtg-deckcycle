# mtg-deckcycle

Ruby script used to login to [Tappedout.net](http://tappedout.net/) and deckcycle a Magic the Gathering deck every three hours between the hours of 9 am and 10 pm.

## Requirements
- Firefox web browser version 27.0 or less
- Ruby

## Installation
`gem install bundler`

`bundle install`

## Usage
```
Usage: deckcycle.rb [options]
    -n, --name [NAME]                Name of deck to deckcycle
    -u, --username [USERNAME]        Tappedout.net username
    -p, --password [PASSWORD]        Tappedout.net password
```
`Example: bundle exec ruby deckcycle.rb -n '<deckname>' -u '<username>' -p '<password>'`
