class RemoveDeliveryPercentageFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :delivery_percentage, :integer
  end
end
