class AddAllOneOrderToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :all_one_order, :boolean, default: true

    Campaign.update_all(all_one_order: true)
  end
end
