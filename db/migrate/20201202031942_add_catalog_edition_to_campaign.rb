class AddCatalogEditionToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :catalog_edition, :string
  end
end
