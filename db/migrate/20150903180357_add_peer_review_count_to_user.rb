class AddPeerReviewCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :peer_review_count, :integer, :default => 0
  end
end
