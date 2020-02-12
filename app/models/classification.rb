# == Schema Information
#
# Table name: text_classifications
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Classification < ActiveRecord::Base
  has_and_belongs_to_many :facsimiles, :uniq => true
  validates_presence_of   :name
  validates_uniqueness_of :name

  default_scope {order :name}
  scope :with_name_like, lambda { |*name|
    where("#{quoted_table_name}.`name` LIKE ?", "%#{name.flatten.first}%") unless name.flatten.first.blank?
  }

  attr_accessible :name
  before_save   :replace_with_another_classification_if_provided
  after_save    :update_related_models unless ENV['DO_NOT_INDEX']
  after_destroy :update_related_models

  attr_accessor :replacement_classification_id

  def self.create_with_name(name)
    return nil if name.nil?
    new_classification = Classification.new(:name => name)
    new_classification.save ? new_classification : nil
  end

  def self.find_or_create_by_name(name)
    return nil if name.nil?
    existing_classification = Classification.find_by_name(name)
    existing_classification ? existing_classification : Classification.create_with_name(name)
  end

  private

  def update_related_models
    facsimiles.collect{|facsimile| facsimile.to_solr}
    Blacklight.solr.commit
  end

  def replace_with_another_classification_if_provided
    unless self.replacement_classification_id.blank?
      replacement_classification = Classification.find(self.replacement_classification_id.to_i)
      if replacement_classification
        self.facsimiles.each do |facsimile|
          facsimile.classifications.delete(self)
          facsimile.classifications << replacement_classification
          facsimile.save
        end
        self.destroy
      end
    end
  end
end
