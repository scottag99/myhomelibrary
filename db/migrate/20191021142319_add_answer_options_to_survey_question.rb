class AddAnswerOptionsToSurveyQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_questions, :answer_options, :json
  end
end
