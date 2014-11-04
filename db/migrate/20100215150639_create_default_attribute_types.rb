class CreateDefaultAttributeTypes < ActiveRecord::Migration
  def self.up
    create_table :default_attribute_types do |t|
      t.string  :model_name
      t.string  :attribute_name
      t.boolean :is_model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :default_attribute_types
  end
end
