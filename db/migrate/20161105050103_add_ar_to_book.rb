class AddArToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :ar_level, :decimal
    add_column :books, :ar_points, :decimal
  end
end
