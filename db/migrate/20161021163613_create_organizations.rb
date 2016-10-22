class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :contact_name
      t.string :contact_email

      t.timestamps
    end
  end
end
