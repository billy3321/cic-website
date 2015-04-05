class AddTypeToCommittees < ActiveRecord::Migration
  def change
    add_column :committees, :kind, :string
  end
end
