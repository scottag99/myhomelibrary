class AddRosterDataReferenceToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :roster_data_reference, :string
  end
end
