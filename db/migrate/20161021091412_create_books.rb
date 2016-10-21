class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.text :description
      t.integer :year
      t.string :isbn
      t.string :cover_image_url
      t.string :level

      t.timestamps
    end
  end
end
