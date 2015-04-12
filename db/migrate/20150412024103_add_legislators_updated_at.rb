class AddLegislatorsUpdatedAt < ActiveRecord::Migration
  def change
    add_column :legislators, :updated_at, :datetime, null: false, default: Time.now
  end
end
