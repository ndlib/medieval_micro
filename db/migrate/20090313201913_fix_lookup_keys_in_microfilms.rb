class FixLookupKeysInMicrofilms < ActiveRecord::Migration
  def self.up
    change_table :microfilms do |t|
      t.remove :hesburgh_location
      t.references :location
      t.references :collection
    end

  end

  def self.down
    change_table :submissions do |t|
      t.remove :location_id, :collection_id
      t.string :hesburgh_location
    end
  end
end
