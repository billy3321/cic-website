class AddTargetToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :target, :string
  end
end
