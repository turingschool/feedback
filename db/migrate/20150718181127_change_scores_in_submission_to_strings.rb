class ChangeScoresInSubmissionToStrings < ActiveRecord::Migration
  def change
    remove_column :submissions, :participation
    add_column :submissions, :participation, :string
    remove_column :submissions, :again
    add_column :submissions, :again, :string
    remove_column :submissions, :valuable
    add_column :submissions, :valuable, :string
  end
end
