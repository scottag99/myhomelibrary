class AddIsIncludedToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :is_included, :boolean, :default => true
  end
end
