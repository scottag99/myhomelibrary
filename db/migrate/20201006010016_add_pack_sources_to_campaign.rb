class AddPackSourcesToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_reference :campaigns, :prek_k_source, foreign_key: { to_table: :catalogs }
    add_reference :campaigns, :first_fifth_source, foreign_key: { to_table: :catalogs }
  end
end
