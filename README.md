# Drain::Cli

`Drain::Cli` saves your energy consumption readings in a sqlite database and prints useful information. Maybe. 

## Installation

Install it yourself as:

    $ gem install drain-cli

Run it!

    $ drain-cli help

## Usage

```
./bin/drain-cli help
Commands:
  drain-cli add USAGE       # add consumption reading
  drain-cli average         # prints average since last reading
  drain-cli delete DATE     # delete readings for date
  drain-cli help [COMMAND]  # Describe available commands or one specific command
  drain-cli import FILE     # imports legacy text file
  drain-cli purge           # deletes everything
  drain-cli readings        # print last n readings
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoyostile/drain-cli.

