# These tests are useless since they don't run in 1.9.2
# I'll redo them in RSpec

#! /usr/bin/env ruby

require 'test/unit'
require 'term/ansicolor'

class String
  include Term::ANSIColorHI
end

class Color
  extend Term::ANSIColorHI
end

class ANSIColorHITest < Test::Unit::TestCase
  include Term::ANSIColorHI

  def setup
    @string = "red"
    @string_red = "\e[31mred\e[0m"
    @string_red_on_green = "\e[42m\e[31mred\e[0m\e[0m"
  end

  attr_reader :string, :string_red, :string_red_on_green

  def test_red
    assert_equal string_red, string.red
    assert_equal string_red, Color.red(string)
    assert_equal string_red, Color.red { string }
    assert_equal string_red, Term::ANSIColorHI.red { string }
    assert_equal string_red, red { string }
  end

  def test_red_on_green
    assert_equal string_red_on_green, string.red.on_green
    assert_equal string_red_on_green, Color.on_green(Color.red(string))
    assert_equal string_red_on_green, Color.on_green { Color.red { string } }
    assert_equal string_red_on_green,
      Term::ANSIColorHI.on_green { Term::ANSIColorHI.red { string } }
    assert_equal string_red_on_green, on_green { red { string } }
  end


  def test_uncolored
    assert_equal string, string_red.uncolored
    assert_equal string, Color.uncolored(string_red)
    assert_equal string, Color.uncolored { string_red }
    assert_equal string, Term::ANSIColorHI.uncolored { string_red }
    assert_equal string, uncolored { string }
  end

  def test_attributes
    foo = 'foo'
    Term::ANSIColorHI.attributes.each do |a, _|
      assert_not_equal foo, foo_colored = foo.__send__(a)
      assert_equal foo, foo_colored.uncolored
      assert_not_equal foo, foo_colored = Color.__send__(a, foo)
      assert_equal foo, Color.uncolored(foo_colored)
      assert_not_equal foo, foo_colored = Color.__send__(a) { foo }
      assert_equal foo, Color.uncolored { foo_colored }
      assert_not_equal foo, foo_colored = Term::ANSIColorHI.__send__(a) { foo }
      assert_equal foo, Term::ANSIColorHI.uncolored { foo_colored }
      assert_not_equal foo, foo_colored = __send__(a) { foo }
      assert_equal foo, uncolored { foo }
    end
  end
end
