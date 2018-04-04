# PhantomDep

Detect your _phantom dependencies_(gems not in use).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phantom_dep', git: 'https://github.com/rosylilly/phantom_dep'
```

And then execute:

    $ bundle


## Usage

1. Add PhantomDep to your Gemfile
2. Load and launch PhantomDep at the very top of your `test/test_helper.rb` (or `spec_helper.rb`, `rails_helper`, cucumber `env.rb`, or whatever your preferred test framework uses):
    ```ruby
    require 'phantom_dep'
    PhantomDep.start

    # Previous content of test helper now starts here
    ```
3. Run your tests

### Example output

```
$ bundle exec rspec

PhantomDep
  has a version number

Finished in 0.00335 seconds (files took 0.56329 seconds to load)
1 example, 0 failures


Gems not in use
 * simplecov (v0.16.1)

Coverage report generated for RSpec to ./coverage. 88 / 88 LOC (100.0%) covered.
```

### Customize

You can configure PhantomDep with start block

```ruby
PhantomDep.start do |pd|
  pd.ignore 'rspec'
end
```

- `ignore`: Ignore a gem of gems not in use
    ```ruby
    PhantomDep.start do |pd|
      pd.ignore 'rspec'
      pd.ignore 'simplecov'
    end
    ```
- `include_dependencies`: Collect gem using by all dependencies(deps by deps).
    ```ruby
    PhantomDep.start do |pd|
      pd.include_dependencies = true
    end
    ```
- `formatters`: Set formatters(default: `[PhantomDep::Formatter::TextFormatter]`
    ```ruby
    PhantomDep.start do |pd|
      pd.formatters = []
    end
    ```
- `auto_report`: Show report at exit(default: `true`)
    ```ruby
    pd = PhantomDep.new
    pd.auto_report = false
    pd.start

    at_exit { pd.report }
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/rosylilly/phantom_dep>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
