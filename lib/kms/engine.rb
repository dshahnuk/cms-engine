require "kms/dependencies"
require "kms/search_item"
require 'kms/drops/page_drop'
require 'kms/drops/search_item_drop'
require 'kms/functions/assets'
require 'kms/functions/currency'
require 'kms/externals/bigdecimal'
require 'kms/externals/request'
require "friendly_id"

module Kms
  class Engine < ::Rails::Engine
    isolate_namespace Kms

    config.eager_load_paths += Dir["#{config.root}/lib/**/"]
    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer "kms.assets" do |app|
      if Kms.skip_ui
        puts 'CMS UI disabled'

        app.config.assets.enabled = false
        app.config.assets.paths = []
      else
        puts 'CMS UI enabled'

        ::Devise::SessionsController.layout "kms/devise"
        ::Devise::RegistrationsController.layout "kms/devise"
        ::Devise::PasswordsController.layout "kms/devise"

        app.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
        app.config.assets.precompile += %w(kms/application.js kms/application.css)
        app.config.assets.precompile += %w( avatar.jpg )
        app.config.assets.precompile += %w( **/*.svg **/*.eot **/*.woff **/*.ttf )
        app.config.assets.precompile += %w( ng-ckeditor/libs/ckeditor/** )
      end
    end

    initializer "kms.compile_templates" do |app|
      app.config.before_initialize do
        errors = Kms::MainService.compile
        errors.each {|error| pp error } if errors.any?
      end
    end

    initializer "kms_models.register_models_collections" do |app|
      app.config.after_initialize do
        Kms::MainService.register_models
      end
    end
  end
end
