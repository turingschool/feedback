class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :invite_set_id
      t.integer :feedback_from_id
      t.integer :feedback_for_id
      t.boolean :completed, :default => false

      t.timestamps null: false
    end
  end
end
