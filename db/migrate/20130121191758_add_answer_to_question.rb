class AddAnswerToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :answer, :string
    add_column :questions, :comment, :string
  end
end
