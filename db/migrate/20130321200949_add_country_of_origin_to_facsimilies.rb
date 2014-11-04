class AddCountryOfOriginToFacsimilies < ActiveRecord::Migration
  def self.up
    add_column :facsimiles, :country_id, :integer
    add_index :facsimiles, :country_id
  end

  def self.down
    remove_column :facsimiles, :country_id
  end
end
