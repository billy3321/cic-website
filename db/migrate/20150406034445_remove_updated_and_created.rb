class RemoveUpdatedAndCreated < ActiveRecord::Migration
  def change
    remove_column :ad_sessions, :created_at
    remove_column :ad_sessions, :updated_at
    remove_column :ads, :created_at
    remove_column :ads, :updated_at
    remove_column :elections, :created_at
    remove_column :elections, :updated_at
    remove_column :legislators, :created_at
    remove_column :legislators, :updated_at
    remove_column :parties, :created_at
    remove_column :parties, :updated_at
  end
end
