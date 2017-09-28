# Heimdall

Heimdall is the all-seeing guardian of gobble's delivery areas. Inotherwords, it houses all gobble's delivery areas and reports when an address does not fall within the delivery areas. It also validates addresses using [Lob](https://github.com/lob/lob-ruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heimdall'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heimdall

## Usage

Ensure `LOB_API_KEY` and `LOB_API_VERSION`environment variables are defined for the Lob client.

#### For Address Validation

In the model that requires address validation, do this:

    $ validates_with Heimdall::AddressValidator

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
