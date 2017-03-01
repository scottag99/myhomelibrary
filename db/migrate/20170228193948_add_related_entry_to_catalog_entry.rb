class AddRelatedEntryToCatalogEntry < ActiveRecord::Migration[5.0]
  def change
    add_column :catalog_entries, :related_entry_id, :integer
    add_foreign_key :catalog_entries, :catalog_entries, column: :related_entry_id
  end
end
