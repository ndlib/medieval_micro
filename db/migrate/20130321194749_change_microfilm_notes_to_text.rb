class ChangeMicrofilmNotesToText < ActiveRecord::Migration
  def self.up
    change_column :microfilms, :mss_note, :text
  end

  def self.down
    change_column :microfilms, :mss_note, :string
  end
end
