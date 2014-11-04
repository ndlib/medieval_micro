# == Schema Information
#
# Table name: default_attribute_values
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  default_attribute_type_id :integer
#  value                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#

class DefaultAttributeValue < ActiveRecord::Base
  belongs_to :user
  belongs_to :default_attribute_type

  delegate :is_model_id, :to => :default_attribute_type
end
