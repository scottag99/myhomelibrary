class AddDisabledToCatalogEntry < ActiveRecord::Migration[5.0]
  def change
    add_column :catalog_entries, :disabled, :boolean, default: false
  end
end
