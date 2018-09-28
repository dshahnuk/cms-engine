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
