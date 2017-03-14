class AddIsBilingualToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :is_bilingual, :boolean, default: false
  end
end
