class CreateGroupings < ActiveRecord::Migration
  def change
    create_table :groupings do |t|
      t.string :content
      t.string :tag

      t.timestamps null: false
    end
  end
end
