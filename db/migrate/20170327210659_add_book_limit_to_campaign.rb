class AddBookLimitToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :book_limit, :integer
  end
end
