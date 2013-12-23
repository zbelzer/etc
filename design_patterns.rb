# Creational Patterns
# =============================================================================

# Abstract Factory:
# Provide an interface for creating families of related or dependent objects
# without specifying their concrete classes.

# In the wild: ActiveRecord::Base
#
# Example in Ruby:

module FooFeature
  def self.widget
    Widget.new
  end
  
  class Widget
    def self.run
      puts "I ran like Foo"
    end
  end
end

module BarFeature
  def self.widget
    Widget.new
  end

  class Widget
    def self.run
      puts "I ran like Bar"
    end
  end
end

class Application
  def initialize(feature)
    widget = feature.widget
    widget.run
  end
end

if RUN_FOO
  Application.new(FooFeature)
else
  Application.new(WinGuiToolkit)
end


# Builder:
# Separate the construction of a complex object from its representation so that
# the same construction process can create different representations.
#
# In the wild: ActionView::Template
#
# Example in Ruby:

class WidgetBuilder
  def initialize(options)
    @options = options
  end

  def build(widget_type)
    widget = widget_finder(@options[:type]).new
    widget.feature = @options[:feature]
    widget
  end

  def widget_finder(type)
    case type
    when :foo then FooWidget
    when :bar then BarWidget
    end
  end
end

builder = WidgetBuilder.new(options)
widget = builder.build


# Factory Method:
# Define an interface for creating an object, but let subclasses decide which
# class to instantiate. +Factory Method+ lets a class defer instantiation to
# subclasses.
#
# In the wild:
#
# Example in Ruby:

class Widget
  def initialize
    @property = decide_property
  end
end

class FooWidget < Widget
  def decide_property
    :foo
  end
end

class BarWidget < Widget
  def decide_property
    :bar
  end
end

# Prototype:
# Specify the kinds of objects to create using a prototypical instance, and
# creating new objects by copying this prototype.
#
# In the wild:
#
# Example in Ruby:

Track = Struct.new(:length, :bend) do
  attr_reader :next_track, :previous_track

  def append(other)
    @next_track = other
    other.prepend(self) unless other.previous_track == self
    @next_track
  end

  def prepend(other)
    @previous_track = other
    other.append(self) unless other.next_track == self
    @previous_track
  end
end

module TrackBox
  extend self

  def fetch(options)
    @prototypes ||= {}

    name = name_from_options(options)

    unless proto = @prototypes[name]
      proto = Track.new(options[:length], options[:bend])
      save_design(name, proto)
    end

    proto.clone
  end

  def name_from_options(options)
    name = options.delete(:name)
    name || "#{options[:length]}_#{options[:bend]}"
  end

  def save_design(name, object)
    @prototypes[name] = object
  end
end

current = TrackBox.fetch(length: 2, bend: :none)
current = current.append(TrackBox.fetch(length: 4, bend: :left))
current = current.append(TrackBox.fetch(length: 4, bend: :right))
current = current.append(TrackBox.fetch(length: 2, bend: :none))

TrackBox.save_design(:s_curve, current)
TrackBox.fetch(name: :s_curve)

# Singleton:
# Ensure a class only has one instance and provide a global point of access to
# it.
#
# References:
# https://practicingruby.com/articles/ruby-and-the-singleton-pattern-dont-get-along?u=dc2ab0f9bb
#
# In the wild:
#
# Mime::NullType             actionpack/lib/action_dispatch/http/mime_type.rb
# ActiveSupport::Deprecation activesupport/lib/active_support/deprecation.rb
#
# Example in Ruby:

# Use the Ruby Module
class Logger
  include Singleton
  def error(message)
    $stderr.puts(message)
  end
end
Logger.instance.error("Danger!")

# Use a Module with Module class-methods
module Logger
  def self.error(message)
    $stderr.puts(message)
  end
end
Logger.error("Danger!")

# Use a fresh object with singleton methods
Logger = Object.new
class << Logger
  def error(message)
    $stderr.puts(message)
  end
end
Logger.error("Danger!")


# Structural Patterns
# =============================================================================

# Adapter:
# Convert the interface of a class into another interface clients expect.
# +Adapter+ lets classes work together that couldn't otherwise because of
# incompatible interfaces.
#
# In the wild:
# Capybara::Driver::Base                           capybara/lib/capybara/driver.rb
# ActiveRecord::ConnectionAdapter::AbstractAdapter activerecord/lib/active_record/connection_adapters.rb
#
# Example in Ruby:
class WebTester
  def run
    adapter.new(Browser.new)
    adapter.visit('page')
  end
end

class Browser
  def render(page)
    # Renders a page of HTML to text
  end
end

BrowserAdapter = Struct.new(:browser) do
  def visit(page)
    browser.render(page)
  end
end

WebTester.run


# Bridge:
# Decouple an abstraction from its implementation so that the two can vary
# independently.
#
# Resources:
# http://en.wikibooks.org/wiki/Computer_Science_Design_Patterns/Bridge
# http://java.dzone.com/articles/design-patterns-bridge
#
# Notes: It seems like the difference here with adapters is that the interface
# to the components is the same. This is like having your core functionality as
# a composite so you can change it out with another without making any subclasses.
# An example of this for the following example would be SamsungRemote and SonyRemote.
#
# In the wild:
#
# Example in Ruby:

class SonyTV < TV
  def on; end
  def off; end
  def set_channel; end
end

class SamsungTV < TV
  def on; end
  def off; end
  def set_channel; end
end

class RemoteControl
  def initialize(implementor)
    @implementor = implementor
  end

  def on
    @implementor.on
  end

  def off
    @implementor.off
  end

  def set_channel(number)
    @implementor.set_channel(number)
  end
end

class FancyRemoteControl < RemoteControl
  def initialize(implementor)
    super(implementor)
    @current_number = 10
  end

  def next
    set_channel(@current_number += 1)
  end

  def previous
    set_channel(@current_number -= 1)
  end
end

# Composite:
# Compose objects into tree structures to represent part-whole hierarchies.
# +Composite+ lets clients treat individual objects and compositions of objects
# uniformly.
#
# Example in Ruby:
#
# In the wild:


# Decorator:
# Attach additional responsibilities to an object dynamically.  Decorators
# provide a flexible alternative to subclassing for extending functionality.
#
# In the wild:
#
# Example in Ruby:
Widget = Struct.new(:name)

# Method missing version
class FancyWidgetDecorator
  def initialize(foo_widget)
    @foo_widget = foo_widget
  end

  def fancy_name
    "#{@foo_widget.name} Mc#{@foo_widget.name}erson"
  end

  def method_missing(name, *args, &block)
    if @foo_widget.respond_to?(name)
      @foo_widget.send(name, *args, &block)
    else
      super(name, *args, &block)
    end
  end
end

FancyWidgetDecorator.new(Widget.new("Steve")).fancy_name

# DelegateClass version
require 'delegate'
class FancyWidgetDecorator < DelegateClass(Widget)
  def fancy_name
    "#{name} Mc#{name}erson"
  end
end

FancyWidgetDecorator.new(Widget.new("Steve")).fancy_name

# Facade:
# Provide a unified interface to a set of interfaces in a subsystem.  +Facade+
# defines a higher level interface that makes the subsystem easier to use.
#
# Example in Ruby:
#
# In the wild:


# Flyweight:
# Use sharing to support large numbers of fine-grained objects efficiently.
#
# Example in Ruby:
#
# In the wild:


# Proxy:
# Provide a surrogate or placeholder for another object to control access to
# it.
#
# Example in Ruby:
#
# In the wild:


# Behavioral Patterns:
# =============================================================================

# Chain of Responsibility:
# Avoid coupling the sender of a request to its receiver by giving more than
# one chance to handle the request. Chain the receiving objects and pass the
# request along the chain until an object handles it.
#
# Example in Ruby:
#
# In the wild:


# Command:
# Encapsulate a request as an object, thereby letting you parameterize clients
# with different requests, queue or log requests, and support undoable
# operations.
#
# Example in Ruby:
#
# In the wild:


# Interpreter:
# Given a language, define a representation for its grammar along with an
# interpreter that uses the representation to interpret sentences in the
# language.
#
# Example in Ruby:
#
# In the wild:


# Iterator:
# Provide a way to access the elements of an aggregate object sequentially
# without exposing the underlying representation.
#
# Example in Ruby:
#
# In the wild:
# Tree level-order


# Mediator:
# Define an object that encapsulates how a set of objects interact.  Mediator
# promotes loose coupling by keeping objects from referring to each other
# explicitly, and it lets you vary their interaction independently.
#
# Example in Ruby:
#
# In the wild:


# Memento:
# Without violating encapsulation, capture and externalize an objects internal
# state so that the object can be restored to this state later.
#
# Example in Ruby:
#
# In the wild:


# Observer:
# Define a one-to-many dependency between objects so that when one object
# changes state, all its dependents are notified and updated automatically.
#
# Example in Ruby:
#
# In the wild:


# State:
# Allow an object to alter its behavior when its internal state changes.  The
# object will appear to change its class.
#
# Example in Ruby:
#
# In the wild:


# Strategy:
# Define a family of algorithms, encapsulate each one, and make them
# interchangeable. Strategy lets the algorithm vary independently from clients
# that use it.
#
# Example in Ruby:
#
# In the wild:


# Template Method:
# Define the skeleton of an algorithm in an operation, deferring some steps to
# subclasses. +Template Method+ lets subclasses redefine certain steps of an
# algorithm without changing the algorithms structure.
#
# Example in Ruby:
#
# In the wild:


# Visitor:
# Represent an operation to be performed on the elements of an object
# structure. +Visitor+ lets you define a new operation without changing the
# classes of the elements on which it operates.
#
# Example in Ruby:
#
# In the wild:
#
