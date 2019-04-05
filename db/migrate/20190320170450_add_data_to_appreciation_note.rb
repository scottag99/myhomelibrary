class AddDataToAppreciationNote < ActiveRecord::Migration[5.1]
  def change
    add_column :appreciation_notes, :data, :text
  end
end
