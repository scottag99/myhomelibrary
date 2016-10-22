class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.date :deadline
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
