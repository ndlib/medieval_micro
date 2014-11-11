require 'rails_helper'

describe Country do
  subject{ Country.create_with_name('United States of America') }
  it 'should create a country' do
    expect(subject).to be_a Country
    expect(subject.id).not_to be_nil
  end

  context 'find or create country' do
    it 'should find a country' do
      subject
      country = Country.find_or_create_by_name('United States of America')
      expect(country.id).to eq(subject.id)
    end

    it 'should create a country' do
      subject
      country = Country.find_or_create_by_name('India')
      expect(country.id).not_to eq(subject.id)
    end
  end

  context 'replace with another country' do

    let(:facsimile) { 
      @facsimile
    }

    before do
      @facsimile = Facsimile.new(title: 'Facsimile 1', shelf_mark: 'A110')
      @facsimile.save

      subject.facsimiles = [@facsimile] 
      subject.save
    end

    it 'should replace name of the Country' do
      expect(subject.name).to eq('United States of America')
      expect(facsimile.country.name).to eq('United States of America')
      old_country_id = facsimile.country_id

      country = Country.create_with_name('USA')

      subject.replacement_country_id = country.id
      subject.save!

      expect{ Country.find(subject.id) }.to raise_error ActiveRecord::RecordNotFound

      reloaded_facsimile = Facsimile.find(@facsimile.id)

      expect(reloaded_facsimile.country.name).to eq('USA')
      expect(old_country_id).not_to eq(facsimile.country_id)
    end
  end
end
