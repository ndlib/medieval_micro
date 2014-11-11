# == Schema Information
#
# Table name: libraries
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  name_variants :string(255)
#  city_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Library < ActiveRecord::Base
  has_many :microfilms
  has_and_belongs_to_many :facsimiles, :uniq => true
  belongs_to :city

  validates_presence_of :name

  default_scope order :name

  scope :ordered, lambda { |*order|
    order( order.flatten.first || 'name' )
  }
  scope :with_name_like, lambda { |*name|
    where("#{quoted_table_name}.`name` LIKE ?", "%#{name.flatten.first}%") unless name.flatten.first.blank?
  }

  attr_accessible :name, :name_variants, :city_id

  after_save    :update_related_models unless ENV['DO_NOT_INDEX']
  after_destroy :update_related_models

  def self.create_with_name(name)
    return nil if name.nil?
    new_library = Library.new(:name => name)
    new_library.save!
    new_library
  end

  def self.find_or_create_by_name(name)
    return nil if name.nil?
    existing_library = Library.find_by_name(name)
    existing_library ? existing_library : Library.create_with_name(name)
  end

  def name_with_city
    city ? "#{name} [#{city.name}]" : name
  end
  alias_attribute :collection_name, :name_with_city

  def city_name
    city ? city.name : nil
  end

  def update_related_models
    facsimiles.collect{|facsimile| facsimile.to_solr}
    microfilms.collect{|microfilm| microfilm.to_solr}
    Blacklight.solr.commit
  end
end
