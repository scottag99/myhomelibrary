class CreateSurveyQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_questions do |t|
      t.string :question
      t.text :description
      t.references :survey, foreign_key: true
      t.references :question_type, foreign_key: true

      t.timestamps
    end
  end
end
