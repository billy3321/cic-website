class RemoveUpdatedAndCreated < ActiveRecord::Migration
  def change
    remove_column :ad_sessions, :created_at, :date
    remove_column :ad_sessions, :updated_at, :date
    remove_column :ads, :created_at, :date
    remove_column :ads, :updated_at, :date
    remove_column :committees, :created_at, :date
    remove_column :committees, :updated_at, :date
    remove_column :elections, :created_at, :date
    remove_column :elections, :updated_at, :date
    remove_column :legislators, :created_at, :date
    remove_column :legislators, :updated_at, :date
    remove_column :parties, :created_at, :date
    remove_column :parties, :updated_at, :date
  end
end
