class CreateClassifications < ActiveRecord::Migration
  def self.up
    create_table :classifications do |t|
      t.string :name

      t.timestamps
    end

    add_index :classifications, :name
  end

  def self.down
    drop_table :classifications
  end
end
