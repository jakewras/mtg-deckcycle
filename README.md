# mtg-deckcycle

Ruby script used to login to Tappedout.net and deckcycle a Magic the Gathering deck every three hours between the hours of 9 am and 10 pm.

## Requirements
- Firefox web browser
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
`Example: ruby deckcycle.rb -n '<deckname>' -u '<username>' -p '<password>'`
