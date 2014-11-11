# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
  has_many :facsimiles
  validates_presence_of   :name
  validates_uniqueness_of :name

  default_scope order :name
  scope :with_name_like, lambda { |*name|
    where("#{quoted_table_name}.`name` LIKE ?", "%#{name.flatten.first}%") unless name.flatten.first.blank?
  }

  before_save   :replace_with_another_country_if_provided
  after_save    :update_related_models unless ENV['DO_NOT_INDEX']
  after_destroy :update_related_models

  attr_accessor :replacement_country_id
  attr_accessible :name

  def self.create_with_name(name)
    return nil if name.nil?
    new_country = Country.new(:name => name)
    new_country.save ? new_country : nil
  end

  def self.find_or_create_by_name(name)
    return nil if name.nil?
    existing_country = Country.find_by_name(name)
    existing_country ? existing_country : Country.create_with_name(name)
  end

  private

  def replace_with_another_country_if_provided
    if replacement_country_id && !(replacement_country_id.to_i == 0)
      replacement_country = Country.find(replacement_country_id.to_i)
      if replacement_country
        self.facsimiles.each do |facsimile|
          facsimile.country_id = replacement_country.id
          facsimile.save
        end

        self.destroy
      end
    end
  end

  def update_related_models
    facsimiles.collect{|facsimile| facsimile.to_solr}
    Blacklight.solr.commit
  end
end
