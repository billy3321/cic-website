class RemoveUpdatedAndCreated < ActiveRecord::Migration
  def change
    remove_column :ad_sessions, :created_at, :datetime
    remove_column :ad_sessions, :updated_at, :datetime
    remove_column :ads, :created_at, :datetime
    remove_column :ads, :updated_at, :datetime
    remove_column :committees, :created_at, :datetime
    remove_column :committees, :updated_at, :datetime
    remove_column :elections, :created_at, :datetime
    remove_column :elections, :updated_at, :datetime
    remove_column :legislators, :created_at, :datetime
    remove_column :legislators, :updated_at, :datetime
    remove_column :parties, :created_at, :datetime
    remove_column :parties, :updated_at, :datetime
  end
end
