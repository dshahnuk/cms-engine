BigDecimal.class_eval do
  include Liquor::External

  export :to_s, :to_i
end
