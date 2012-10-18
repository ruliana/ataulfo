module Kernel
  def with(object, &block)
    other_self = eval "self", block.binding
    to_match   = Ataulfo::PatternMatching.new(object, other_self)
    to_match.instance_eval(&block)
  end
end
