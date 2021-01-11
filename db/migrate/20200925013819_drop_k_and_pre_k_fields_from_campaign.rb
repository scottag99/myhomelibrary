class DropKAndPreKFieldsFromCampaign < ActiveRecord::Migration[5.2]
  def change
    remove_column :campaigns, :k_english_qty
    remove_column :campaigns, :k_bilingual_qty
    remove_column :campaigns, :pre_k_english_qty
    remove_column :campaigns, :pre_k_bilingual_qty
  end
end
