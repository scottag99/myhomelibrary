class AddSequenceToSurveyQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_questions, :sequence, :int, default: 1
    SurveyQuestion.where("sequence is null").update_all("sequence = id")
  end
end
