class AddPeerReviewScoreToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :peer_review_score, :integer, :default => 0
  end
end
