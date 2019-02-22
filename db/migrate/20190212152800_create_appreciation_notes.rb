class CreateAppreciationNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :appreciation_notes do |t|
      t.references :wishlist, foreign_key: true
      t.binary :note

      t.timestamps
    end
  end
end
