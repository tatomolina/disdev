class AddAnswerToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :answer, :text
  end
end
