class AddUseAppreciationNotesToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :use_appreciation_notes, :boolean, default: false
  end
end
