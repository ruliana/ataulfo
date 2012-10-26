module Ataulfo
  class PatternMatching
    class Var < Struct.new(:value);
    end

    class Body
      def initialize(vars, other_self)
        @other_self = other_self
        vars.each do |k, v|
          define_singleton_method(k) { v.value }
        end
      end

      def method_missing(method_name, *args, &block)
        @other_self.send method_name, *args, &block
      end
    end

    class Matcher
      def initialize(object, pattern)
        @object                      = object
        @pattern_vars                = pattern.select { |_, v| v.is_a? Var }
        inner_matches                = pattern.select { |_, v| v.is_a? Hash }
        fixed_values                 = pattern.select { |_, v| !v.is_a?(Var) && !v.is_a?(Hash) }
        @object_respond_to_methods   = pattern.keys.all? { |k| @object.respond_to? k }
        @object_answers_right_values = fixed_values.all? { |k, v| @object.send(k) == v }

        @matchers = inner_matches.map { |k, v| Matcher.new(object.send(k), v) }
      end

      def matches?
        @matchers.all?(&:matches?) if @object_respond_to_methods && @object_answers_right_values
      end

      def fill_vars
        @pattern_vars.each { |k, v| v.value = @object.send k }
        @matchers.each(&:fill_vars)
      end
    end

    def initialize(object, other_self)
      @object       = object
      @other_self   = other_self
      @context_vars = { }
    end

    def like(pattern, &block)
      matcher = Matcher.new(@object, pattern)
      return unless matcher.matches?

      matcher.fill_vars

      Body.new(@context_vars, @other_self).instance_eval(&block)
      @context_vars = { }
    end

    def method_missing(method_name, *_)
      # The line below also returns the "Var" to the
      # pattern. That makes it a collector parameter
      # already distributed where it belongs to.
      @context_vars[method_name] = Var.new
    end
  end
end
