module Kms
  class User < ActiveRecord::Base
    self.table_name = Kms.user_table_name if Kms.user_table_name

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    ROLES = %i[admin content_manager]

    def admin?
      role == "admin"
    end

    def localized_role
      I18n.t("roles.#{role}")
    end

    def remember_created_at=(value)
    end
  end
end
