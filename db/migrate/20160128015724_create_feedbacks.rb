class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :token
      t.text :text

      t.timestamps null: false
    end
  end
end
