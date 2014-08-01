# Two Way Mapper [![Build Status](https://travis-ci.org/timsly/two-way-mapper.svg?branch=master)](https://travis-ci.org/timsly/two-way-mapper)

Two way data mapping

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'two-way-mapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install two-way-mapper

## Usage

First, we need to define mapping

```ruby
TwoWayMapper.register :customer do |mapping|
  mapping.left :object # set left plugin to object
  mapping.right :hash, stringify_keys: true # set right plugin to hash

  # define transformation rules
  mapping.rule 'first_name', 'FirstName'
  mapping.rule 'last_name', 'LastName'
  mapping.rule 'gender', 'sex',
    map: {
      'M' => 'male',
      'F' => 'female'
    }, default: ''
end
```

Once mapping is defined we can convert one object to another and vice versa

```ruby
Customer = Struct.new :first_name, :last_name, :gender

customer = Customer.new
api_response = { 'FirstName' => 'Evee', 'LastName' => 'Fjord', 'sex' => 'female' }

TwoWayMapper[:customer].from_right_to_left customer, api_response
puts customer.first_name # => 'Evee'
puts customer.last_name # => 'Fjord'
puts customer.gender # => 'F'

request_data = {}

another_customer = Customer.new
another_customer.first_name = 'Step'
another_customer.last_name = 'Bander'
another_customer.gender = 'M'

TwoWayMapper[:customer].from_left_to_right another_customer, request_data
puts request_data # => { 'FirstName' => 'Step', 'LastName' => 'Bander', sex: 'male' }
```

On rails, you can put all mappings into `app/mappings` folder

### Available plugins

* hash
* object
* active_record (same as object, but for keys like `user.email`, it will try to build `user` before updating `email` on write)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
