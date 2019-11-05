class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  belongs_to :question_type
end
