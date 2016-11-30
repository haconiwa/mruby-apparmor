# mruby-apparmor   [![Build Status](https://travis-ci.org/haconiwa/mruby-apparmor.svg?branch=master)](https://travis-ci.org/haconiwa/mruby-apparmor)
AppArmor class
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'haconiwa/mruby-apparmor'
end
```
## example
```ruby
p AppArmor.hi
#=> "hi!!"
t = AppArmor.new "hello"
p t.hello
#=> "hello"
p t.bye
#=> "hello bye"
```

## License
under the MIT License:
- see LICENSE file
