module Kms
  module Functions
    module Custom
      include Liquor::Library

      function 'str_find', unnamed_arg: :string,
        mandatory_named_args: { pattern: :string } do |arg, kw|

        arg.scan(Regexp.new(kw[:pattern]))
      end

    end
  end
end
