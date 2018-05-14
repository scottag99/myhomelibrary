class AddBookDataReferenceToCatalog < ActiveRecord::Migration[5.1]
  def change
    add_column :catalogs, :book_data_reference, :string
  end
end
