# frozen_string_literal: true

def fn
  a = 3.tap { yield :a }
  p a
  b = yield :b
  [a, b]
end

p(fn do |a|
  p '$$$' + a.inspect
  break 1 if a == :b

  2
end)
