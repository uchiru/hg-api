# Hg::Api

Ruby API client for Hosted Graphite.

## Installation

Add this line to your application's Gemfile:

    gem 'hg-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hg-api

## Usage

```ruby
client = HGAPI.new
client.metric("signup", 1)
client.metric("load", 100, via: :tcp)
```

Default transport is udp, it can be changed by passing options hash while
constructing client:

```ruby
client = HGAPI.new(via: :http)
client.metric("this.metric.send.over.http", 5)
```

Supported transports: udp, tcp, http.

API KEY must be present as environmental variable HOSTED_GRAPHITE_API_KEY.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hg-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
