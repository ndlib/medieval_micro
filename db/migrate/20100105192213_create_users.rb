class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :netid
      t.boolean :administrator, :default => false

      t.timestamps
    end

    add_index :users, :netid
    add_index :users, :administrator
  end

  def self.down
    remove_index :users, :administrator
    remove_index :users, :netid
    drop_table :users
  end
end
