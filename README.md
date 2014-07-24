# JrubyHive

## Installation

Add this line to your application's Gemfile:

    gem 'jruby_hive'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jruby_hive

## Usage


    #!/usr/bin/env jruby
    # encoding utf-8

    require 'jruby_hive'

    hive = Hive.new
    p hive.run("show tables")

## Contributing

1. Fork it ( https://github.com/[my-github-username]/jruby_hive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
