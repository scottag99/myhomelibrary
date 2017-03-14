class AddDraToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :dra, :string
  end
end
