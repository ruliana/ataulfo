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

    def initialize(object, other_self, vars = { })
      @object     = object
      @other_self = other_self
      @vars       = vars
    end

    def fill_vars(pattern)
      vars                        = -> { pattern.select { |_, v| v.is_a? Var } }
      inner_matches               = -> { pattern.select { |_, v| v.is_a? Hash } }
      fixed_values                = -> { pattern.select { |_, v| !v.is_a?(Var) && !v.is_a?(Hash) } }
      object_respond_to_methods   = -> { pattern.keys.all? { |k| @object.respond_to? k } }
      object_answers_right_values = -> { fixed_values[].all? { |k, v| @object.send(k) == v } }

      match = false
      if object_respond_to_methods[] && object_answers_right_values[]
        match = true
        vars[].each do |k, v|
          v.value = @object.send k
        end
        inner_matches[].each do |k, v|
          match &&= PatternMatching.new(@object.send(k), @other_self, @vars).fill_vars(v)
        end
      end
      match
    end

    def like(pattern, &block)
      match = fill_vars(pattern)
      Body.new(@vars, @other_self).instance_eval(&block) if match
      @vars = { }
    end

    def method_missing(method_name, *_)
      @vars[method_name] = Var.new
    end
  end
end
