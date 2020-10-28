# Clientus

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/clientus`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clientus'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install clientus

## Usage

Case 1: Suppose you have an URL of the uploading interface
```ruby
require 'clientus'

# simply create a client instance
client = Clientus::Client.new(url)

# then upload your file!
client.upload('foo/bar.txt')

# now bar.txt is somewhere on the server (or some exception appeared.. ouch!)
```

Case 2: You have some headers you want to pass along (ex.: session sid)
```ruby
require 'clientus'

# describe your headers
# NOTE: tus-specific headers will be rewritten or adjusted
# ex.: if you defined Tus-Resumable header, its value will be replaced with one from the server
custom_headers = {
  'Cookie' => 'sid=09876543211234567890'
}

# pass your headers when creating a client instance
client = Clientus::Client.new(url, additional_headers: custom_headers)

# upload a file!
client.upload('foo/bar.txt')
```

Case 3: You want to use some custom http config (ex: you want to turn off the sertificate verification)
```ruby
require 'clientus'

# describe a required http config
http_params = {
  use_ssl: true,
  verify_mode: OpenSSL::SSL::VERIFY_NONE
}

# pass your headers when creating a client instance
client = Clientus::Client.new(url, http_params: http_params)

# upload a file!
client.upload('foo/bar.txt')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/clientus.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
