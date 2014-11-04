# == Schema Information
#
# Table name: default_attribute_types
#
#  id             :integer          not null, primary key
#  model_name     :string(255)
#  attribute_name :string(255)
#  is_model_id    :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

class DefaultAttributeType < ActiveRecord::Base
  has_many :default_attribute_values, :dependent => :destroy
  has_many :users, :through => :default_attribute_values
end
