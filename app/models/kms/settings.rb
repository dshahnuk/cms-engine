module Kms
  class Settings < ActiveRecord::Base

    serialize :values

    def self.instance
      first_or_create
    end

    def self.get(key)
      instance.values[key]
    end

    def self.set(key, value)
      settings = instance
      settings.values[key] = value
      settings.save!
    end
  end
end
