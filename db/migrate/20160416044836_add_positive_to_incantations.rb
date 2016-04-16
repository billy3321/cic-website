class AddPositiveToIncantations < ActiveRecord::Migration
  def change
    add_column :incantations, :positive, :boolean, default: true
  end
end
