require 'rails_helper'

describe City do
  subject{ City.create_with_name('South Bend') }
  it 'should create a city' do
    expect(subject).to be_a City
    expect(subject.id).not_to be_nil
  end

  context 'find or create city' do
    it 'should find a city' do
      subject
      city = City.find_or_create_by_name('South Bend')
      expect(city.id).to eq(subject.id)
    end

    it 'should create a city' do
      subject
      city = City.find_or_create_by_name('Notre Dame')
      expect(city.id).not_to eq(subject.id)
    end
  end
end
