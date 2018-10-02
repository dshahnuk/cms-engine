module Kms
  class ResourceService
    cattr_accessor :resources do
      {}
    end

    NON_TEMPLATABLE_CLASSES = [Page, Template, Asset, User, Snippet].freeze

    def self.register(group, resource, tab_icon_class)
      self.resources[group] ||= {}
      self.resources[group][resource] = tab_icon_class
    end

    def self.unregister(group, resource)
      self.resources[group].delete(resource)
    end

    def self.external_resources_hash
      self.resources.values.map(&:keys).flatten.reject {|r| NON_TEMPLATABLE_CLASSES.include?(r)}.map do |resource_class|
        {type: resource_class.name, title: resource_class.model_name.human}
      end
    end

    def self.register_all
      self.resources = {}

      Kms::ResourceService.register(:content_management, Kms::Template, "fa-support")
      Kms::ResourceService.register(:content_management, Kms::Page, "fa-sitemap")
      Kms::ResourceService.register(:content_management, Kms::Asset, "fa-image")
      Kms::ResourceService.register(:content_management, Kms::User, "fa-users")
      Kms::ResourceService.register(:content_management, Kms::Snippet, "fa-bookmark")
      Kms::ResourceService.register(:models, Kms::Model, "fa-tasks")

      if Kms::Model.table_exists?
        Kms::Model.all.each do |model|
          Kms::ResourceService.register(:models, model, "fa-tasks")
        end
      end
    end
  end
end
