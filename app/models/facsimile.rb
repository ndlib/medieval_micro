# == Schema Information
#
# Table name: facsimiles
#
#  id                       :integer          not null, primary key
#  title                    :string(255)
#  alternate_names          :string(255)
#  shelf_mark               :string(255)
#  origin                   :string(255)
#  dimensions               :string(255)
#  century_keywords         :string(255)
#  date_description         :string(255)
#  author                   :string(255)
#  content                  :text
#  hand                     :text
#  illuminations            :boolean
#  type_of_decoration       :text
#  musical_notation         :boolean
#  type_of_musical_notation :text
#  call_number              :string(255)
#  commentary_volume        :boolean
#  nature_of_facsimile      :text
#  series                   :string(255)
#  publication_date         :string(255)
#  place_of_publication     :string(255)
#  publisher                :string(255)
#  printer                  :string(255)
#  notes                    :text
#  bibliography             :text
#  created_at               :datetime
#  updated_at               :datetime
#  country_id               :integer
#

class Facsimile < ActiveRecord::Base
  has_and_belongs_to_many :classifications, :uniq => true
  has_and_belongs_to_many :date_ranges,     :uniq => true
  has_and_belongs_to_many :languages,       :uniq => true
  has_and_belongs_to_many :libraries,       :uniq => true
  belongs_to :country

  attr_accessible :title, :shelf_mark, :alternate_names, :origin, :dimensions, :century_keywords, :date_description,
    :author, :content, :hand, :illuminations, :type_of_decoration, :musical_notation, :type_of_musical_notation,
    :call_number, :commentary_volume, :nature_of_facsimile, :series, :publication_date, :place_of_publication, :publisher,
    :printer, :notes, :bibliography, :country_id

  validates_presence_of :shelf_mark, :message => "A facsimile must have a shelf mark."

  after_save    :update_solr unless ENV['DO_NOT_INDEX']
  after_destroy :remove_from_solr

  def solr_id
    "facsimile-#{id}"
  end

  def has_illuminations
    illuminations ? 'Yes' : 'No'
  end

  def has_commentary_volume
    commentary_volume ? 'Yes' : 'No'
  end

  def has_musical_notation
    musical_notation ? 'Yes' : 'No'
  end

  def country_of_origin
    self.country.name rescue nil
  end

  def library_names
    if libraries.any?
      libraries.collect{|library| library.name}
    else
      nil
    end
  end

  def library_city_names
    if libraries.any?
      libraries.collect{|library| library.city_name}
    else
      nil
    end
  end

  def date_range_names
    if date_ranges.any?
      date_ranges.collect{|date_range| date_range.name}
    else
      nil
    end
  end

  def language_names
    if languages.any?
      languages.collect{|language| language.name }
    else
      nil
    end
  end

  def type_of_text
    if classifications.any?
      classifications.collect{|classification| classification.name}
    else
      nil
    end
  end

  def as_solr
    {
      :id                         => solr_id,
      :format                     => self.class.name,
      :title_s                    => title,
      :alternate_names_s          => alternate_names,
      :library_facet              => library_names,
      :city_facet                 => library_city_names,
      :shelf_mark_s               => shelf_mark,
      :origin_s                   => origin,
      :country_of_origin_facet    => country_of_origin,
      :dimensions_s               => dimensions,
      :century_keywords_s         => century_keywords,
      :date_description_s         => date_description,
      :date_range_facet           => date_range_names,
      :language_facet             => language_names,
      :author_s                   => author,
      :content_s                  => content,
      :hand_s                     => hand,
      :illuminations_facet        => has_illuminations,
      :type_of_decoration_s       => type_of_decoration,
      :musical_notation_facet     => has_musical_notation,
      :type_of_musical_notation_s => type_of_musical_notation,
      :call_number_s              => call_number,
      :commentary_volume_facet    => has_commentary_volume,
      :nature_of_facsimile_s      => nature_of_facsimile,
      :series_s                   => series,
      :publication_date_s         => publication_date,
      :place_of_publication_s     => place_of_publication,
      :publisher_s                => publisher,
      :printer_s                  => printer,
      :notes_s                    => notes,
      :bibliography_s             => bibliography,
      :classification_facet       => type_of_text
    }.reject{|key, value| value.blank?}
  end

  def to_solr
    Blacklight.solr.add as_solr
  end

  def update_solr
    to_solr
    Blacklight.solr.commit
  end

  private

  def remove_from_solr
    Blacklight.solr.delete_by_id solr_id
    Blacklight.solr.commit
  end

end
