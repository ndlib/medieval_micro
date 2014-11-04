class CreateMicrofilms < ActiveRecord::Migration
  def self.up
    create_table :microfilms do |t|
      t.string :shelf_mark
      t.string :mss_name
      t.string :mss_note
      t.string :hesburgh_location

      t.timestamps
    end
  end

  def self.down
    drop_table :microfilms
  end
end
