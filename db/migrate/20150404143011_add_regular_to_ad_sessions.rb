class AddRegularToAdSessions < ActiveRecord::Migration
  def change
    add_column :ad_sessions, :regular, :boolean
  end
end
