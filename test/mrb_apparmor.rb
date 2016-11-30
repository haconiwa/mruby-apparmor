##
## AppArmor Test
##

assert("AppArmor#hello") do
  t = AppArmor.new "hello"
  assert_equal("hello", t.hello)
end

assert("AppArmor#bye") do
  t = AppArmor.new "hello"
  assert_equal("hello bye", t.bye)
end

assert("AppArmor.hi") do
  assert_equal("hi!!", AppArmor.hi)
end
