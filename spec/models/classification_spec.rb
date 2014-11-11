require 'rails_helper'

describe Classification do
  subject{ Classification.create_with_name('Class 1') }
  it 'should create a classification' do
    expect(subject).to be_a Classification
    expect(subject.id).not_to be_nil
  end

  context 'find or create classification' do
    it 'should find a classification' do
      subject
      classification = Classification.find_or_create_by_name('Class 1')
      expect(classification.id).to eq(subject.id)
    end

    it 'should create a classification' do
      subject
      classification = Classification.find_or_create_by_name('Class 2')
      expect(classification.id).not_to eq(subject.id)
    end
  end

  context 'replace with another classification' do

    let(:facsimile) { 
      @facsimile
    }

    before do
      @facsimile = Facsimile.new(title: 'Facsimile 1', shelf_mark: 'A110')
      @facsimile.save

      subject.facsimiles = [@facsimile] 
      subject.save
    end

    it 'should replace name of the Classification' do
      classification = Classification.create_with_name('Class A')

      expect(subject.name).to eq('Class 1')
      expect(facsimile.classifications).to include(subject)
      expect(facsimile.classifications).not_to include(classification)
      old_classification_id = subject.id


      subject.replacement_classification_id = classification.id
      subject.save!

      expect{ Classification.find(subject.id) }.to raise_error ActiveRecord::RecordNotFound

      reloaded_facsimile = Facsimile.find(@facsimile.id)

      expect(reloaded_facsimile.classifications).not_to include(subject)
      expect(reloaded_facsimile.classifications).to include(classification)
      expect(old_classification_id).not_to eq(classification.id)
    end
  end
end
