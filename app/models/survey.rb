class Survey < ApplicationRecord
  has_many :survey_questions, -> { order(sequence: :asc) }
end
