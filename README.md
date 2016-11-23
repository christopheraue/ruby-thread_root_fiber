# ThreadRootFiber

Ruby's threads have no access to their root fibers. This little gem adds:

- Thread#root_fiber
- Fiber.root
- Fiber#root? (also aliased as #root_fiber?)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thread_root_fiber'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thread_root_fiber

## Usage

`Thread#root_fiber`:
```ruby
Thread.main.root_fiber == Fiber.current # => true
Thread.main.root_fiber != Thread.new{ Fiber.current }.value # => true

thread = Thread.new{ Fiber.current }
thread.root_fiber == thread.value # => true
thread.root_fiber != Fiber.current # => true
```

`Fiber.root`:
```ruby
Fiber.root == Fiber.current # => true
Fiber.root != Thread.new{ Fiber.current }.value # => true

thread = Thread.new{ Fiber.root }
thread.value == thread.root_fiber # => true
thread.value != Fiber.root # => true
```

`Fiber#root?`:
```ruby
Fiber.current.root? # => true
Fiber.new.root? # => false

Thread.new{ Fiber.current.root? }.value # => true
Thread.new{ Fiber.new.root? }.value # => false
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

