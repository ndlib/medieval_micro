class AddReelToMicrofilms < ActiveRecord::Migration
  def self.up

    change_table :microfilms do |t|
      t.string :reel
    end
	
  end

  def self.down

    change_table :microfilms do |t|
      t.remove :reel
    end

  end
end
