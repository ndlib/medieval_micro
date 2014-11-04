class CreateFacsimiles < ActiveRecord::Migration
  def self.up
    create_table :facsimiles do |t|
      t.string  :title
      t.string  :alternate_names
      t.string  :shelf_mark
      t.string  :origin
      t.string  :dimensions
      t.string  :century_keywords
      t.string  :date_description
      t.string  :author
      t.text    :content
      t.text    :hand
      t.boolean :illuminations
      t.text    :type_of_decoration
      t.boolean :musical_notation
      t.text    :type_of_musical_notation
      t.string  :call_number
      t.boolean :commentary_volume
      t.text    :nature_of_facsimile
      t.string  :series
      t.string  :publication_date
      t.string  :place_of_publication
      t.string  :publisher
      t.string  :printer
      t.text    :notes
      t.text    :bibliography

      t.timestamps
    end
  end

  def self.down
    drop_table :facsimiles
  end
end
