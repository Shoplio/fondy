# Fondy

[![Build status](https://travis-ci.org/busfor/fondy.svg?branch=master)](https://travis-ci.org/busfor/fondy)
[![Code Climate](https://codeclimate.com/github/busfor/fondy/badges/gpa.svg)](https://codeclimate.com/github/busfor/fondy)

Ruby wrapper for Fondy API: https://portal.fondy.eu/en/info/api/v1.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fondy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fondy

## Usage

First, create API client:

```ruby
client = Fondy::Client.new(merchant_id: 1, password: 'qwerty')
```

Check payment status:

```ruby
response = client.status(order_id: 2)

response.success?
# => true
response.order_status
# => "approved"

response.error?
# => true
response.error_code
# => 1018
response.error_message
# => "Order not found"
```

Capture payment:

```ruby
response = client.capture(order_id: 2, amount: 100, currency: 'USD')
```

Refund payment:

```ruby
response = client.reverse(order_id: 2, amount: 100, currency: 'USD')

response = client.reverse(order_id: 2, amount: 100, currency: 'USD', comment: '...')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/busfor/fondy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
