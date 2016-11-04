class AddReadyForDonationsToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :ready_for_donations, :boolean
  end
end
