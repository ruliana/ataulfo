module Ataulfo
  class PatternMatching
    class Var < Struct.new(:value);
    end

    class Body
      def initialize(vars, other_self)
        @vars, @other_self = vars, other_self
      end

      def method_missing(method, *args, &block)
        result = @vars[method]
        if result
          result.value
        else
          @other_self.send method, *args, &block
        end
      end
    end

    class Matcher
      def initialize(object, pattern)
        @object                      = object
        @vars                        = pattern.select { |_, v| v.is_a? Var }
        inner_matches                = pattern.select { |_, v| v.is_a? Hash }
        fixed_values                 = pattern.select { |_, v| !v.is_a?(Var) && !v.is_a?(Hash) }
        @object_respond_to_methods   = pattern.keys.all? { |k| @object.respond_to? k }
        @object_answers_right_values = fixed_values.all? { |k, v| @object.send(k) == v }

        @matchers = inner_matches.map { |k, v| Matcher.new(object.send(k), v) }
      end

      def matches?
        match = false
        if @object_respond_to_methods && @object_answers_right_values
          match = @matchers.all?(&:matches?)
        end
        match
      end

      def fill_vars
        @vars.each { |k, v| v.value = @object.send k }
        @matchers.each(&:fill_vars)
      end
    end

    def initialize(object, other_self, vars = { })
      @object     = object
      @other_self = other_self
      @vars       = vars
    end

    def like(pattern, &block)
      matcher = Matcher.new(@object, pattern)
      return unless matcher.matches?

      matcher.fill_vars

      Body.new(@vars, @other_self).instance_eval(&block)
      @vars = { }
    end

    def method_missing(method_name, *_)
      # The line below also returns the "Var" to the
      # pattern. That makes it a collector parameter
      # already distributed where it belongs to.
      @vars[method_name] = Var.new
    end
  end
end
