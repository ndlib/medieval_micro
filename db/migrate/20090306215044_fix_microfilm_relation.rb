class FixMicrofilmRelation < ActiveRecord::Migration
  def self.up
    change_table :microfilms do |t|
      t.references :library
    end
  end

  def self.down
    change_table :microfilms do |t|
      t.remove :library_id
    end 
  end
end
