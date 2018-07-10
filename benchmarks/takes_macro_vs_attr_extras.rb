require "benchmark/ips"
require "attr_extras"
require "takes_macro"

class A
  pattr_initialize :a, [:b!, :c]
end

TakesMacro.monkey_patch_object

class B
  takes :a, [:b!, :c]
end

class C
  def initialize(a, b:, c: nil)
    @a = a
    @b = b
    @c = c
  end

  private

  attr_reader :a, :b, :c
end

Benchmark.ips do |x|
  x.report("attr_extras") do
    A.new(:a, b: :b)
  end

  x.report("takes_macro") do
    B.new(:a, b: :b)
  end

  x.report("hand written initializer") do
    C.new(:a, b: :b)
  end

  x.compare!
end
