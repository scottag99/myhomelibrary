class CreateCampaignCatalogs < ActiveRecord::Migration[5.0]
  def change
    create_table :campaign_catalogs do |t|
      t.references :campaign, foreign_key: true
      t.references :catalog, foreign_key: true

      t.timestamps
    end
    Campaign.all.each{|c| Catalog.all.each{|cat| c.campaign_catalogs.create({:catalog => cat})}}
  end
end
