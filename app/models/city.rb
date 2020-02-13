# == Schema Information
#
# Table name: cities
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  name_variants :string(255)
#  notes         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class City < ActiveRecord::Base
  has_many :libraries
  validates_presence_of :name

  default_scope { order :name }
  attr_accessible :name, :name_variants, :notes

  scope :ordered, -> { where(:order => ['name ASC']) }
  scope :attributes_for_select_list, -> { where(:select =>[ '`name`, `id`']) }
  scope :with_name_like, lambda { |*name|
    where("#{quoted_table_name}.`name` LIKE ?", "%#{name.flatten.first}%") unless name.flatten.first.blank?
  }

  after_save    :update_related_models unless ENV['DO_NOT_INDEX']
  after_destroy :update_related_models

  def self.create_with_name(name)
    return nil if name.nil?
    new_city = City.new(:name => name)
    new_city.save!
    new_city
  end

  def self.find_or_create_by_name(name)
    return nil if name.nil?
    existing_city = City.find_by_name(name)
    existing_city ? existing_city : City.create_with_name(name)
  end

  def update_related_models
    libraries.collect{|library| library.update_related_models}
  end
end
