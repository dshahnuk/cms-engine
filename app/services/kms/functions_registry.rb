module Kms
  class FunctionsRegistry
    cattr_accessor :modules do
      [Liquor::Pagination, Kms::Functions::Assets, Kms::Functions::Currency, Kms::Functions::Custom]
    end

    def self.register(module_const)
      modules << module_const
    end
  end
end
