class CreateCatalogEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :catalog_entries do |t|
      t.references :catalog, foreign_key: true
      t.references :book, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
