require "test_helper"

class TakesMacroTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TakesMacro::VERSION
  end

  def setup
    TakesMacro.monkey_patch_object
  end

  test "defines private attr readers and ivar" do
    klass = Class.new do
      takes [:foo!, :bar!]
    end

    obj = klass.new(foo: :one, bar: :two)

    assert_equal :one, obj.instance_variable_get(:"@foo")
    assert_equal :two, obj.instance_variable_get(:"@bar")

    assert_equal :one, obj.send(:foo)
    assert_equal :two, obj.send(:bar)

    assert_raises(NoMethodError) { obj.foo }
    assert_raises(NoMethodError) { obj.bar }
  end

  test "supports just one optional arg" do
    klass = Class.new do
      takes [:bar]
    end

    obj = klass.new

    assert_nil obj.instance_variable_get(:"@foo")

    assert_nil obj.send(:foo)

    assert_raises(NoMethodError) { obj.foo }
  end

  test "supports optional args" do
    klass = Class.new do
      takes [:foo!, :bar]
    end

    obj = klass.new(foo: :one)

    assert_equal :one, obj.instance_variable_get(:"@foo")
    assert_nil obj.instance_variable_get(:"@bar")

    assert_equal :one, obj.send(:foo)
    assert_nil obj.send(:bar)

    assert_raises(NoMethodError) { obj.foo }
    assert_raises(NoMethodError) { obj.bar }
  end

  test "supports positional args" do
    klass = Class.new do
      takes :foo, :bar
    end

    obj = klass.new(:one, :two)

    assert_equal :one, obj.instance_variable_get(:"@foo")
    assert_equal :two, obj.instance_variable_get(:"@bar")

    assert_equal :one, obj.send(:foo)
    assert_equal :two, obj.send(:bar)

    assert_raises(NoMethodError) { obj.foo }
    assert_raises(NoMethodError) { obj.bar }
  end

  test "supports mixed hash and positional args" do
    klass = Class.new do
      takes :foo, :bar, [:baz!, :qux]
    end

    obj = klass.new(:one, :two, baz: :three)

    assert_equal :one, obj.instance_variable_get(:"@foo")
    assert_equal :two, obj.instance_variable_get(:"@bar")
    assert_equal :three, obj.instance_variable_get(:"@baz")
    assert_nil obj.instance_variable_get(:"@qux")

    assert_equal :one, obj.send(:foo)
    assert_equal :two, obj.send(:bar)
    assert_equal :three, obj.send(:baz)
    assert_nil obj.send(:qux)
  end

  test "raises if there are extra unknown hash args" do
    klass = Class.new do
      takes [:foo!]
    end

    assert_raises(ArgumentError) { klass.new(foo: :one, bar: :two) }
  end

  test "raises if there are extra unknown with optional hash args" do
    klass = Class.new do
      takes [:foo]
    end

    assert_raises(ArgumentError) { klass.new(foo: :one, bar: :two) }

    klass.new(foo: :one)
  end

  test "raises if there are extra unknown positional args" do
    klass = Class.new do
      takes :foo
    end

    assert_raises(ArgumentError) { klass.new(:foo, :bar) }
  end

  test "raises if there are extra unknown mixed args" do
    klass = Class.new do
      takes :foo, [:bar!]
    end

    assert_raises(ArgumentError) { klass.new(:foo, bar: :bar, baz: :baz) }
    assert_raises(ArgumentError) { klass.new(bar: :bar, baz: :baz) }
  end
end
