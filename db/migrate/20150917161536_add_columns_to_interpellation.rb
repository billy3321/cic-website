class AddColumnsToInterpellation < ActiveRecord::Migration
  def change
    add_column :interpellations, :interpellation_type, :string
    add_column :interpellations, :record_url, :string
  end
end
