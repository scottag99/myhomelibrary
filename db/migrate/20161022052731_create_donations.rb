class CreateDonations < ActiveRecord::Migration[5.0]
  def change
    create_table :donations do |t|
      t.references :wishlist, foreign_key: true
      t.decimal :amount
      t.string :confirmation_code

      t.timestamps
    end
  end
end
