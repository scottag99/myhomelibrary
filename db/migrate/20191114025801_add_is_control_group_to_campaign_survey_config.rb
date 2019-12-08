class AddIsControlGroupToCampaignSurveyConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :campaign_survey_configs, :is_control_group, :boolean
  end
end
