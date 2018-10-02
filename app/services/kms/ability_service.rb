module Kms
  class AbilityService
    cattr_accessor :abilities do
      []
    end

    def self.register(&block)
      self.abilities << block
    end

    def self.register_all
      self.abilities = []

      if Kms::Model.table_exists?
        Kms::Model.all.each do |model|
          register do
            can :manage, model
          end
        end
      end
    end
  end
end
