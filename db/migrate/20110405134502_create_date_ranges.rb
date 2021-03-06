class CreateDateRanges < ActiveRecord::Migration
  def self.up
    create_table :date_ranges do |t|
      t.string :name
      t.string :code
      t.date   :start_date
      t.date   :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :date_ranges
  end
end
