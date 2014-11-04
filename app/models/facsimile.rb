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
      :id                               => solr_id,
      :format                           => self.class.name,
      :title_display                    => title,
      :alternate_names_display          => alternate_names,
      :library_facet                    => library_names,
      :city_facet                       => library_city_names,
      :shelf_mark_display               => shelf_mark,
      :origin_display                   => origin,
      :country_of_origin_facet          => country_of_origin,
      :dimensions_display               => dimensions,
      :century_keywords_display         => century_keywords,
      :date_description_display         => date_description,
      :date_range_facet                 => date_range_names,
      :language_facet                   => language_names,
      :author_display                   => author,
      :content_display                  => content,
      :hand_display                     => hand,
      :illuminations_facet              => has_illuminations,
      :type_of_decoration_display       => type_of_decoration,
      :musical_notation_facet           => has_musical_notation,
      :type_of_musical_notation_display => type_of_musical_notation,
      :call_number_display              => call_number,
      :commentary_volume_facet          => has_commentary_volume,
      :nature_of_facsimile_display      => nature_of_facsimile,
      :series_display                   => series,
      :publication_date_display         => publication_date,
      :place_of_publication_display     => place_of_publication,
      :publisher_display                => publisher,
      :printer_display                  => printer,
      :notes_display                    => notes,
      :bibliography_display             => bibliography,
      :classification_facet             => type_of_text
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
