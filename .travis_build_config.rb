MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem '../mruby-apparmor'
  conf.gem github: 'haconiwa/mruby-exec'

  conf.enable_test
end
