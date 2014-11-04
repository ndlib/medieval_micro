# == Schema Information
#
# Table name: date_ranges
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  start_date :date
#  end_date   :date
#  created_at :datetime
#  updated_at :datetime
#

class DateRange < ActiveRecord::Base
  has_and_belongs_to_many :facsimiles, :uniq => true
  validates_uniqueness_of :code

  default_scope order('`date_ranges`.`start_date` ASC')

  attr_reader :lower_bounds, :upper_bounds

  after_initialize :set_bounds
  before_save      :update_name
  after_save       :update_related_models unless ENV['DO_NOT_INDEX']
  after_destroy    :update_related_models

  def self.create_date_range_with_code(code)
    return nil if code.nil?
    new_date_range = DateRange.new(:code => code)
    new_date_range.save ? new_date_range : nil
  end

  def self.find_or_create_by_code(code)
    return nil if code.nil?
    existing_date_range = DateRange.find_by_code(code)
    existing_date_range ? existing_date_range : DateRange.create_date_range_with_code(code)
  end

  def year_or_label(date)
    if date > lower_bounds && date < upper_bounds
      date.year
    elsif date <= lower_bounds
      'pre'
    elsif date >= upper_bounds
      'post'
    end
  end

  def update_related_models
    facsimiles.collect{|facsimile| facsimile.to_solr}
    Blacklight.solr.commit
  end

  private

  def update_name
    if self.start_date && self.end_date
      self.name = "#{year_or_label(start_date)}-#{year_or_label(end_date)}"
    else
      self.name = self.code
    end
  end

  def set_bounds
    @lower_bounds = Date.new(100)
    @upper_bounds = Date.new(1600)
  end
end
