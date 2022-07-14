# Ruby Calculator

Build a memo-ized calculator with ease.  Calculate complex, interrelated metrics, statistics, and other values incredibly fast.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ldstudios_ruby_calculator', git: 'https://github.com/ldstudios/ruby-calculator.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ldstudios_ruby_calculator

## Usage

```ruby
class Calculator::Simple < Calculator::Base
  attr_accessor :left, :right
  
  calculate(:sum) { left + right }
  
  calculate(:difference) { left - right }
  
  calculate(:product) { left * right }
  
  calculate(:quotient) { left / right }
  
  calculate(:average) do
    sum / 2
  end
end
```

This simple calculator lets you calculate basic arithmetic between two values, left and right.  It uses predefined blocks to ensure calculations are not re-calculated.

```ruby
calculator = Calculator::Simple.new(left: 1, right: 1)

calculator.average
calculator.sum
```

In this example, the `average` method calls `sum`.  When the `sum` method is invoked directly, the value is already calculated and stored.  The calculator will not repeat this method but will instead return the previously stored value.  

This pattern is incredibly fast when calculating inter-related, time-consuming, and computationally expensive operations.  Memoization FTW!  

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ldstudios_ruby_calculator.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
