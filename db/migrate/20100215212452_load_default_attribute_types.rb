class LoadDefaultAttributeTypes < ActiveRecord::Migration
  def self.up
    DefaultAttributeType.new( :model_name => 'Library',    :attribute_name => 'library_id',    :is_model_id => true ).save
    DefaultAttributeType.new( :model_name => 'Collection', :attribute_name => 'collection_id', :is_model_id => true ).save
  end

  def self.down
    DefaultAttributeType.find_by_attribute_name('library_id').destroy
    DefaultAttributeType.find_by_attribute_name('collection_id').destroy
  end
end
