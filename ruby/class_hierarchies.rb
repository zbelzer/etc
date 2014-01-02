#!/usr/local/env ruby

require 'rubygems'
require 'text-table'

class A; end
class B < A; end

obj             = B.new
clazz           = obj.class
singleton_class = clazz.singleton_class

puts "Method Lookup"
puts <<TEXT

When looking up a method, see if it's defined in the singleton class of the
current object and then look in the singleton class' ancestor chain if it is not.
Continue until we run out of ancestors.

This works for both regular objects and classes since they're both objects.

With regular objects, the trick is that the superclass of the singleton class
on an object is the class of the object.

With classes, methods defined on the singleton class *are* the class methods so
it works exactly the same way. When looking for a method on a class, look at
the singleton class first and then look up the ancestor chain.

Modules included into a class are inserted into the class's ancestors while
Modules that are extended are inserted into the singleton class' ancestor
chain.

TEXT

table =
  [
    ["", "", "Class #{clazz.superclass.superclass.superclass}", "== singleton class ==>", singleton_class.superclass.superclass.superclass],
    ["", "", "^^ superclass ^^", "", "^^ superclass ^^"],
    ["", "", "Class #{clazz.superclass.superclass}", "== singleton class ==>", singleton_class.superclass.superclass],
    ["", "", "^^ superclass ^^", "", "^^ superclass ^^"],
    ["", "", "Class #{clazz.superclass}", "== singleton class ==>", singleton_class.superclass],
    ["", "", "^^ superclass ^^", "", "^^ superclass ^^"],
    ["Instance of B", "== class ==>", "Class #{clazz}", "== singleton class ==>", singleton_class],
    ["", "", "^^ superclass ^^", "", ""],
    ["Instance of B", "== singleton class ==>", obj.singleton_class, "", ""]
  ].to_table

puts table
