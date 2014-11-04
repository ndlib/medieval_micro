class CreateClassificationsFacsimilies < ActiveRecord::Migration
  def self.up
    create_table :classifications_facsimiles, :id => false do |t|
      t.integer :facsimile_id,      :null => false
      t.integer :classification_id, :null => false
    end

    add_index :classifications_facsimiles, :facsimile_id
    add_index :classifications_facsimiles, :classification_id
    add_index :classifications_facsimiles, [:facsimile_id, :classification_id], :name => 'index_classifications_facsimiles_on_both_ids'
  end

  def self.down
    drop_table :classifications_facsimiles
  end
end
