class CampaignSurveyConfig < ApplicationRecord
  belongs_to :campaign
  belongs_to :survey
end
