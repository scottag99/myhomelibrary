class CreateReadingLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :reading_levels do |t|
      t.string :name
      t.boolean :is_disabled

      t.timestamps
    end
    ('A'..'Z').each{|ltr| ReadingLevel.create(name: ltr, is_disabled: false)}
  end
end
