CLI - Chitter
=============

## Brief description

The goal was to build console-based social networking application (similar to Twitter) satisfying the scenarios outlined in [RULES.md](RULES.md).


## Technologies used

- Ruby
- RSpec

## How to use

To run the program:
```
ruby lib/chitter.rb
```

Further explanation will be given in the terminal.


If you would like to play around with the internals of the program:
```
irb
require './lib/chitter'
```

To create a new chitter:
```
chitter = Chitter.new(method(:puts),method(:gets))
```

To post:
```
chitter.post("Greg", %w{I am loving this!})
```

To follow:
```
chitter.follow("Greg", "Bob")
```

To see Greg's wall:
```
chitter.wall("Greg")
```

and so on...

## How to test
Just type:
```
rspec
```