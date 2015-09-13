class AddTokenToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :token, :string
  end
end
