class ResetSearchesTable < ActiveRecord::Migration
  def self.up
    remove_index :searches, :user_id
    drop_table   :searches

    create_table :searches do |t|
      t.text     :query_params
      t.integer  :user_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :user_type

      t.timestamps
    end
    add_index :searches, [:user_id], :name => 'index_searches_on_user_id'
  end

  def self.down
  end
end
