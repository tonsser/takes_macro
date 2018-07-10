$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "takes_macro"

require "minitest/autorun"

class Minitest::Test
  def self.test(name, &block)
    define_method("test_#{name}", &block)
  end
end
