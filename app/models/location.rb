# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  notes      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
  has_many :microfilms

  default_scope order :name

  scope :ordered, :order => 'name ASC'
  scope :attributes_for_select_list, :select => '`name`, `id`'

  after_save    :update_related_models unless ENV['DO_NOT_INDEX']
  after_destroy :update_related_models

  def update_related_models
    microfilms.collect{|microfilm| microfilm.to_solr}
    Blacklight.solr.commit
  end
end
