# LogPlot

Plot requests per period vs time from web server access logs using Gnuplot.

This is a gemified version of
http://www.keepthingssimple.net/2012/10/creating-requests-per-time-graph-from-nginx-or-apache-access-log/

## Installation

Install it:

    $ gem install log-plot

You'll also need to install [Gnuplot](http://www.gnuplot.info/) for your
system.

## Usage

```
Usage: log-plot [-opt] log_file

Specific options:
    -p, --period PERIOD              Specify requests per period for plotting
                                       from 1 to 3600 seconds
    -o, --output OUTPUT              Filename of outputted plot
    -t, --type TYPE                  Log type (access, error)
    -h, --help                       Show this message
    -V, --version                    Show version
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec log-plot` to use the code located in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/donal/log-plot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
