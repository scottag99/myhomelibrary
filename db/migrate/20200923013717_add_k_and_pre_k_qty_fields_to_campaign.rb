class AddKAndPreKQtyFieldsToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :k_english_qty, :integer
    add_column :campaigns, :k_bilingual_qty, :integer
    add_column :campaigns, :pre_k_english_qty, :integer
    add_column :campaigns, :pre_k_bilingual_qty, :integer
  end
end
