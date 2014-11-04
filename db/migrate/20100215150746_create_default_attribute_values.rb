class CreateDefaultAttributeValues < ActiveRecord::Migration
  def self.up
    create_table :default_attribute_values do |t|
      t.integer :user_id
      t.integer :default_attribute_type_id
      t.string  :value

      t.timestamps
    end

    add_index :default_attribute_values, :user_id
    add_index :default_attribute_values, :default_attribute_type_id 
  end

  def self.down
    remove_index :default_attribute_values, :default_attribute_type_id
    remove_index :default_attribute_values, :user_id
    drop_table :default_attribute_values
  end
end
