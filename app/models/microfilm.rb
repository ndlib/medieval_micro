# == Schema Information
#
# Table name: microfilms
#
#  id            :integer          not null, primary key
#  shelf_mark    :string(255)
#  mss_name      :string(255)
#  mss_note      :text
#  created_at    :datetime
#  updated_at    :datetime
#  library_id    :integer
#  location_id   :integer
#  collection_id :integer
#  reel          :string(255)
#

class Microfilm < ActiveRecord::Base
  belongs_to :library
  belongs_to :location
  belongs_to :collection

  validates_presence_of :shelf_mark, :message => "A microfilm must have a shelf mark."
  attr_accessible :mss_name, :shelf_mark, :mss_note, :library_id, :location_id, :collection_id, :reel

  after_save    :update_solr unless ENV['DO_NOT_INDEX']
  after_destroy :remove_from_solr

  scope :with_shelf_mark, lambda { |*shelf_mark|
    where("#{quoted_table_name}.`shelf_mark` LIKE ?", "%#{shelf_mark.flatten.first}%") unless shelf_mark.flatten.first.blank?
  }

  def solr_id
    "microfilm-#{id}"
  end

  def library_name
    library.name rescue nil
  end

  def library_city_name
    library.city_name rescue nil
  end

  def collection_name
    collection.name rescue nil
  end

  def location_name
    location.name rescue nil
  end

  def as_solr
    {
      :id                        => solr_id,
      :title_display             => solr_id,
      :format                    => self.class.name,
      :library_facet             => library_name,
      :city_facet                => library_city_name,
      :shelf_mark_display        => shelf_mark,
      :mss_name_display          => mss_name,
      :mss_note_display          => mss_note,
      :collection_facet          => collection_name,
      :reel_display              => reel,
      :hesburgh_location_display => location_name
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
