class RemoveRoleFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :administrator
  end

  def self.down
    add_column :users, :administrator, :boolean, :default => false
  end
end
