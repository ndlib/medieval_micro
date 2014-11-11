require 'rails_helper'

describe DateRange do
  subject{ DateRange.create_date_range_with_code('1') }
  it 'should create a date_range' do
    expect(subject).to be_a DateRange
    expect(subject.id).not_to be_nil
  end

  context 'find or create date_range' do
    it 'should find a date_range' do
      subject
      date_range = DateRange.find_or_create_by_code('1')
      expect(date_range.id).to eq(subject.id)
    end

    it 'should create a date_range' do
      subject
      date_range = DateRange.find_or_create_by_code('2')
      expect(date_range.id).not_to eq(subject.id)
    end
  end

end
