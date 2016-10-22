class CreateWishlists < ActiveRecord::Migration[5.0]
  def change
    create_table :wishlists do |t|
      t.string :reader_name
      t.integer :reader_age
      t.string :reader_gender
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
