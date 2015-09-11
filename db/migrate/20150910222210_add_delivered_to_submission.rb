class AddDeliveredToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :delivered, :boolean, :default => false
  end
end
