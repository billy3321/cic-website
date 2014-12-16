class CreateLegislatorsNews < ActiveRecord::Migration
  def change
    create_table :legislators_news, id: false do |t|
      t.belongs_to :legislator
      t.belongs_to :new
    end
  end
end
