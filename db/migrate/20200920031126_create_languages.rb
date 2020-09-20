class CreateLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :languages do |t|
      t.string :name
      t.boolean :is_disabled

      t.timestamps
    end
    Language.create(name: 'BI', is_disabled: false)
  end
end
