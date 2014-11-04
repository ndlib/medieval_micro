class DeviseUpdateUsers < ActiveRecord::Migration
  def self.up
    # devise expects the username to be stored in the username field
    remove_index  :users, :netid
    rename_column :users, :netid, :username
    add_index     :users, :username

    # devise rememberable
    add_column :users, :remember_token,      :string
    add_column :users, :remember_created_at, :datetime

    # devise trackable
    add_column :users, :sign_in_count,      :integer,  :default => 0
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at,    :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip,    :string
  end

  def self.down
    remove_index  :users, :username
    rename_column :users, :username, :netid
    add_index     :users, :netid
    remove_column :users, :remember_token
    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
  end
end
