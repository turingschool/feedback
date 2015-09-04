class AddDeliveryPercentageToUser < ActiveRecord::Migration
  def change
    add_column :users, :delivery_percentage, :integer, :default => 0
  end
end
