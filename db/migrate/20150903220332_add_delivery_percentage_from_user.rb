class AddDeliveryPercentageFromUser < ActiveRecord::Migration
  def change
    add_column :users, :delivery_percentage, :float, :default => 0.0
  end
end
