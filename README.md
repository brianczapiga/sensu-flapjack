# Sensu-Flapjack Pipe Handler

## Installation

- Clone:
```
$ git clone git@github.com:brianczapiga/sensu-flapjack.git
```
- Select version:
```
$ cd sensu-flapjack
$ git tag
v1.6.0
v2.0.0
$ git checkout v1.6.0
```
- Install gems:
```
$ gem install bundler
$ bundle install
```

## Usage

```
{
  "handlers": {
    "flapjack": {
      "type": "pipe",
#      "command": "/etc/sensu/handlers/flapjack.rb -h 127.0.0.1 -p 6380 -c events -d 0"
      "command": "/etc/sensu/handlers/flapjack.rb"
    }
  }
}
```

Note that a check must be either defined as type _metric_ or in a state other than OK in order to be passed to a standard file (pipe) handler.

## Sources

Uses source and fragments from:

- https://github.com/sensu/sensu
- https://github.com/sensu/sensu-community-plugins/commits/e58c1f3ce39c6c0ca271fadd470c04362e92b190/extensions/handlers/flapjack.rb
- https://github.com/flapjack/flapjack

## License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
