module Ataulfo
  class PatternMatching
    class Var < Struct.new(:value);  end

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

    def initialize(object, other_self)
      @object     = object
      @other_self = other_self
      @vars       = { }
    end

    def like(pattern, &block)
      vars                        = -> { pattern.select { |_, v| v.is_a? Var } }
      fixed_values                = -> { pattern.select { |_, v| !v.is_a? Var } }
      object_respond_to_methods   = -> { pattern.keys.all? { |k| @object.respond_to? k } }
      object_answers_right_values = -> { fixed_values[].all? { |k, v| @object.send(k) == v } }

      if object_respond_to_methods[] && object_answers_right_values[]
        vars[].each { |k, v| v.value = @object.send k }
        Body.new(@vars, @other_self).instance_eval(&block)
      end
      @vars = { }
    end

    def method_missing(method_name, *_)
      @vars[method_name] = Var.new
    end
  end
end
