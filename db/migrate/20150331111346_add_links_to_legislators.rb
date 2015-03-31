class AddLinksToLegislators < ActiveRecord::Migration
  def change
    add_column :legislators, :fb_link,    :string
    add_column :legislators, :wiki_link,  :string
    add_column :legislators, :musou_link, :string
    add_column :legislators, :ccw_link,   :string
    add_column :legislators, :ivod_link,  :string
  end
end
