class CreateSurveys < ActiveRecord::Migration[5.1]
  def change
    create_table :surveys do |t|
      t.string :name
      t.boolean :is_disabled, default: false
      t.text :description

      t.timestamps
    end
  end
end
