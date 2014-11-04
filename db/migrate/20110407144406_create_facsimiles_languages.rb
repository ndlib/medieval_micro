class CreateFacsimilesLanguages < ActiveRecord::Migration
  def self.up
    create_table :facsimiles_languages, :id => false do |t|
      t.integer :facsimile_id, :null => false
      t.integer :language_id,  :null => false
    end

    add_index :facsimiles_languages, :facsimile_id
    add_index :facsimiles_languages, :language_id
    add_index :facsimiles_languages, [:facsimile_id, :language_id]
  end

  def self.down
    drop_table :facsimiles_languages
  end
end
