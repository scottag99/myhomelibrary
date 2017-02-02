class AddAddressFieldToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :address, :string
  end
end
