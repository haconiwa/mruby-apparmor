# mruby-apparmor   [![Build Status](https://travis-ci.org/haconiwa/mruby-apparmor.svg?branch=master)](https://travis-ci.org/haconiwa/mruby-apparmor)

A mruby gem to access libapparmor API

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
profile_name = "haconiwa-foobar"
AppArmor.change_profile(profile_name)

## if you want to apply profile on container:
AppArmor.change_onexec(profile_name)
exec "/bin/bash"
```

## License

AppArmor is under LGPL. mruby-apparmor itself is under the MIT License:

- see LICENSE file
