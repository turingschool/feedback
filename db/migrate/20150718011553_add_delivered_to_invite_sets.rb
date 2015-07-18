class AddDeliveredToInviteSets < ActiveRecord::Migration
  def change
    add_column :invite_sets, :delivered, :boolean, :default => false
  end
end
