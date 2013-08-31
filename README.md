# Itudes

This is a small utitility class to simplify multitude handling in ruby.

There are few handy things:
- `String` class is monkeypatched with `to_itude` method, which does
converts to `Float` any of the following strings:
  - 53.1234565
  - 53°11′18″N
  - 53 11 18N 
- The distance between two points on the Earth is calculated with one
single method call.

## Installation

Add this line to your application's Gemfile:

    gem 'itudes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itudes

## Usage

      itudes = Geo::Itudes.new 53.15, -18.44
      puts itudes - "53°11′18″N,37°5′18″E"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
