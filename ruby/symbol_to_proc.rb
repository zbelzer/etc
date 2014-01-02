#!/usr/bin/env ruby

test = %w(one two three)

# Typical symbol to Proc:
result = test.map(&:upcase.to_proc)
puts result.join(' ') # => "ONE TWO THREE"

# Translates to:
result = test.map { |s| s.upcase }
puts result.join(' ') # => "ONE TWO THREE"

# Because the interpreter sees the '&' it wants to covert a Proc to a block.
# Since a Symbol is not a Proc, :to_proc is magically called on it.

Symbol.class_eval do
  def my_to_proc
    Proc.new {|target| target.send(self)}
  end
end

# We still have to prefix the argument with '&' in order for it to be passed as
# a block instead of a Proc.
result = test.map(&(:upcase.my_to_proc))
puts result.join(' ') # => "ONE TWO THREE"

# As a reminder, on the other side in a method definition, '&' serves to go the
# other direction, converting a block to a Proc:
def block_to_proc(&block)
  block
end

result = block_to_proc { |s| s.upcase }
puts result.inspect     # => #<Proc:0x000000021c2300@symbol_to_proc.rb:32>
puts result.call("foo") # => "FOO"

# Then we can go the other way again if we want
puts test.map(&result).join(' ') # => "ONE TWO THREE"
