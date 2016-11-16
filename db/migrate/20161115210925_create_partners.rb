class CreatePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :email
      t.boolean :active
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
