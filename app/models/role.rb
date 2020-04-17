# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :uniq => true
  validates_presence_of   :name
  validates_uniqueness_of :name

  before_save :update_user_collection

  attr_accessible :name, :usernames

  def self.find_or_create_by_name(name)
    existing_role = self.find_by_name(name)
    existing_role ? existing_role : self.create(:name => name)
  end

  def usernames
    collection = users.map{|u| u.username}
    collection.size > 0 ?  "#{collection.join(', ')}, " : ""
  end

  def usernames=(value)
    @usernames = value.split(',').reject{|i| i.blank?}.map{|i| i.strip}
  end

  private

  def update_user_collection
    user_ids = []
    @usernames ||= []
    @usernames.each do |username|
      user_ids << User.find_or_create_by(username: username).id unless username.blank?
    end
    user_ids.uniq!
    self.user_ids = user_ids
  end
end
