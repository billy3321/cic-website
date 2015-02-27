class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name
    end
  end
end
