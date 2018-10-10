Array.class_eval do
  include Liquor::External

  export :size, :[]
end
