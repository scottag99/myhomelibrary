class CreateQuestionTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :question_types do |t|
      t.string :name

      t.timestamps
    end
    QuestionType.create!(name: 'Freetext')
    QuestionType.create!(name: 'Rating')
    QuestionType.create!(name: 'Multiple')
  end
end
