class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :invite_id
      t.integer :participation
      t.integer :valuable
      t.integer :again
      t.text :comments
      t.integer :feedback_from_id
      t.integer :feedback_for_id

      t.timestamps null: false
    end
  end
end
