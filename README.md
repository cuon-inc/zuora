# Zuora

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/zuora`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zuora'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install zuora

## Usage

### Initialization

You can set the zuora endpoint, zuora client id, and zuora client secret in environment variables:

```bash
export ZUORA_ENDPOINT="endpoint"
export ZUORA_CLIENT_ID="client_id"
export ZUORA_CLIENT_SECRET="client_secret"
```

### Global configuration

You can set any of the options globally:
```ruby
Zuora.configure do |config|
  config.endpoint = 'endpoint'
  config.client_id = 'client_id'
  config.client_secret = 'client_secret'
  config.logger = Logger.new('/path/to/logfile')
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/zuora.
