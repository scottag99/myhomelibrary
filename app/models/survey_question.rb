class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  belongs_to :question_type

  include RailsSortable::Model
  set_sortable :sequence  # Indicate a sort column
end
