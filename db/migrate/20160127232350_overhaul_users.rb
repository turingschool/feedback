class OverhaulUsers < ActiveRecord::Migration
  def change
    add_column :users, :slack_id, :string
    add_column :users, :slack_token, :string
    add_column :users, :slack_name, :string
    remove_column :users, :peer_review_count, :integer
    remove_column :users, :delivery_percentage, :float
    remove_column :users, :password_digest, :string
    remove_column :users, :cohort, :integer
  end
end
