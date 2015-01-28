class AddNowPartyIdToLegislators < ActiveRecord::Migration
  def change
    add_column :legislators, :now_party_id, :integer
  end
end
