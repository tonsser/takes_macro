require "takes_macro/version"

module TakesMacro
  def self.monkey_patch_object
    Object.send(:include, TakesMacro)
  end

  def takes(*args)
    positional_args = args.reject { |arg| arg.is_a?(Array) }
    keyword_args = if args.last.is_a?(Array)
                     args.last.map(&:to_s)
                   else
                     []
                   end
    all_args = (positional_args + keyword_args).flatten.map do |arg|
      arg.to_s.delete("!")
    end

    args_code = [
      positional_args,
    ]

    if keyword_args.any?
      args_code << "options"
    end

    args_code = args_code.flatten.compact.join(", ")

    bind_positional_args_code = positional_args.map do |arg|
      "@#{arg} = #{arg}"
    end.join("\n")

    bind_keywords_args_code = keyword_args.map do |arg|
      code = if arg =~ /!$/
        arg = arg.delete("!")
        "@#{arg} = options.fetch(:#{arg})"
      else
        "@#{arg} = options[:#{arg}]"
      end
      [code, "options.delete(:#{arg})"].join("\n")
    end.join("\n")

    define_private_attr_readers_code = all_args.map do |arg|
      <<-RUBY
        attr_reader :#{arg}
        private :#{arg}
      RUBY
    end.join("\n")

    ensure_options_are_empty =
      if keyword_args.any?
        <<-EOS
          unless options == {}
            raise ArgumentError, "Not all initialize args were used: \#{options.keys.inspect}"
          end
        EOS
      else
        ""
      end

    code = <<-RUBY
      def initialize(#{args_code})
        #{bind_positional_args_code}
        #{bind_keywords_args_code}
        #{ensure_options_are_empty}
        after_takes
      end
      #{define_private_attr_readers_code}

      def after_takes; end
    RUBY

    class_eval code
  end
end
