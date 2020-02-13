# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Language < ActiveRecord::Base
  has_and_belongs_to_many :facsimiles, :uniq => true
  validates_presence_of   :name
  validates_uniqueness_of :name

  default_scope {order :name}
  scope :with_name_like, lambda { |*name|
    where("#{quoted_table_name}.`name` LIKE ?", "%#{name.flatten.first}%") unless name.flatten.first.blank?
  }

  before_save   :replace_with_another_language_if_provided
  after_save    :update_related_models unless ENV['DO_NOT_INDEX']
  after_destroy :update_related_models

  attr_accessor :replacement_language_id
  attr_accessible :replacement_language_id, :name

  def self.create_with_name(name)
    return nil if name.nil?
    new_language = Language.new(:name => name)
    new_language.save ? new_language : nil
  end

  def self.find_or_create_by_name(name)
    return nil if name.nil?
    existing_language = Language.find_by_name(name)
    existing_language ? existing_language : Language.create_with_name(name)
  end

  private

  def replace_with_another_language_if_provided
    if self.replacement_language_id.present?
      replacement_language = Language.find(self.replacement_language_id.to_i)
      if replacement_language
        self.facsimiles.each do |facsimile|
          facsimile.languages.delete(self)
          facsimile.languages << replacement_language
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
