class AddIsChapterToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :is_chapter, :boolean, :default => false
  end
end
