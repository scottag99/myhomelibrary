class CreateSurveyResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_responses do |t|
      t.references :wishlist, foreign_key: true
      t.references :survey, foreign_key: true

      t.timestamps
    end
  end
end
