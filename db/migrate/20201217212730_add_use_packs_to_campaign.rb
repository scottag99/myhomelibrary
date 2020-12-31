class AddUsePacksToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :use_packs, :boolean
  end
end
