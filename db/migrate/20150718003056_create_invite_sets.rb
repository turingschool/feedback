class CreateInviteSets < ActiveRecord::Migration
  def change
    create_table :invite_sets do |t|
      t.string :title
      t.text :groups

      t.timestamps null: false
    end
  end
end
