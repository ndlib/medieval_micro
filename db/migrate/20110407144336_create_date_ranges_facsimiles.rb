class CreateDateRangesFacsimiles < ActiveRecord::Migration
  def self.up
    create_table :date_ranges_facsimiles, :id => false do |t|
      t.integer :facsimile_id,  :null => false
      t.integer :date_range_id, :null => false
    end

    add_index :date_ranges_facsimiles, :facsimile_id
    add_index :date_ranges_facsimiles, :date_range_id
    add_index :date_ranges_facsimiles, [:facsimile_id, :date_range_id]
  end

  def self.down
    drop_table :date_ranges_facsimiles
  end
end
