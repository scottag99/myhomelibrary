class CreateCatalogs < ActiveRecord::Migration[5.0]
  def change
    create_table :catalogs do |t|
      t.string :name
      t.boolean :active
      t.string :source

      t.timestamps
    end
  end
end
