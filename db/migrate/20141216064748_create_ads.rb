class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :name
      t.date :vote_date
      t.date :term_start
      t.date :term_end

      t.timestamps
    end
  end
end
