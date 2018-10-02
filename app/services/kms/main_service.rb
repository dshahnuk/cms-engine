require 'ostruct'

module Kms
  class MainService
    def self.register_resources
      Kms::ExternalsRegistry.register_all
      Kms::AbilityService.register_all
      Kms::ResourceService.register_all
    end

    def self.register_models
      Kms::Model.pluck(:collection_name).each do |collection_name|
        Kms::ModelsWrapperDrop.register_model collection_name
      end if Kms::Model.table_exists?
    end

    def self.compile
      Kms.template_manager = Liquor::Manager.new(import: Kms::FunctionsRegistry.modules)

      if ActiveRecord::Base.connection.tables.include?('kms_templates')
        Template.all.each do |template|
          Kms.template_manager.register_layout(template.register_id, template.content || "", Kms::ExternalsRegistry.externals.keys)
        end
      end
      if ActiveRecord::Base.connection.tables.include?('kms_pages')
        Page.all.each do |page|
          Kms.template_manager.register_template(page.register_id, page.content || "", Kms::ExternalsRegistry.externals.keys)
        end
      end
      if ActiveRecord::Base.connection.tables.include?('kms_snippets')
        Snippet.all.each do |snippet|
          Kms.template_manager.register_partial(snippet.register_id, snippet.content || "")
        end
      end

      Kms.template_manager.compile ? [] : Kms.template_manager.errors
    end

    def self.refresh
      register_resources
      register_models
      compile

      Settings.set(:dirty, false)
    end

    def self.render(path)
      refresh if Settings.get(:dirty).present? || ExternalsRegistry.externals.empty?

      request = OpenStruct.new(params: {path: path})

      externals = Hash[ExternalsRegistry.externals.map{ |k, v| [k, v.call(request, nil)] }]
      page = externals[:page].source
      template = page.template

      page_result = Kms.template_manager.render(page.register_id, externals)
      result = Kms.template_manager.render(template.register_id, externals.merge(_inner_template: page_result))

      {html: result.html_safe, status: page.not_found? ? :not_found : :ok}
    rescue ActiveRecord::RecordNotFound
      {status: :not_found}
    end
  end
end