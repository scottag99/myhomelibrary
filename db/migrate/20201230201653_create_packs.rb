class CreatePacks < ActiveRecord::Migration[5.2]
  def change
    create_table :packs do |t|
      t.string :ezid
      t.string :pack_type
      t.decimal :price
      t.string :description
      t.references :catalog, foreign_key: true

      t.timestamps
    end
  end
end
