class CreateKmsSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :kms_settings, force: true do |t|
      t.json :values

      t.timestamps null: false
    end
  end
end
