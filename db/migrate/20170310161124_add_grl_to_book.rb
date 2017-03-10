class AddGrlToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :grl, :string
  end
end
