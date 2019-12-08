class CreateCampaignSurveyConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_survey_configs do |t|
      t.references :campaign, foreign_key: true
      t.references :survey, foreign_key: true
      t.string :teacher
      t.boolean :is_disabled, default: false

      t.timestamps
    end
  end
end
