class AddIsGradeSponsoredToDonation < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :is_grade_sponsorship, :boolean
  end
end
