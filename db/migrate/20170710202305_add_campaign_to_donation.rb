class AddCampaignToDonation < ActiveRecord::Migration[5.0]
  def change
    add_reference :donations, :campaign, foreign_key: true
  end
end
