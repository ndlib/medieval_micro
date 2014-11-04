class CreateFacsimilesLibraries < ActiveRecord::Migration
  def self.up
    create_table :facsimiles_libraries, :id => false do |t|
      t.integer :facsimile_id, :null => false
      t.integer :library_id,   :null => false
    end

    add_index :facsimiles_libraries, :facsimile_id
    add_index :facsimiles_libraries, :library_id
    add_index :facsimiles_libraries, [:facsimile_id, :library_id]
  end

  def self.down
    drop_table :facsimiles_libraries
  end
end
