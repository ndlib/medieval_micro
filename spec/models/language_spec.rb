require 'rails_helper'

describe Language do
  subject{ Language.create_with_name('English') }
  it 'should create a language' do
    expect(subject).to be_a Language
    expect(subject.id).not_to be_nil
  end

  context 'find or create language' do
    it 'should find a language' do
      subject
      language = Language.find_or_create_by_name('English')
      expect(language.id).to eq(subject.id)
    end

    it 'should create a language' do
      subject
      language = Language.find_or_create_by_name('Sanskrit')
      expect(language.id).not_to eq(subject.id)
    end
  end

  context 'replace with another language' do

    let(:facsimile) { 
      @facsimile
    }

    before do
      @facsimile = Facsimile.new(title: 'Facsimile 1', shelf_mark: 'A110')
      @facsimile.save

      subject.facsimiles = [@facsimile] 
      subject.save
    end

    it 'should replace Language' do
      language = Language.create_with_name('Sanskrit')

      expect(subject.name).to eq('English')
      expect(facsimile.languages).to include(subject)
      expect(facsimile.languages).not_to include(language)
      old_language_id = subject.id


      subject.replacement_language_id = language.id
      subject.save!

      expect{ Language.find(subject.id) }.to raise_error ActiveRecord::RecordNotFound

      reloaded_facsimile = Facsimile.find(@facsimile.id)

      expect(reloaded_facsimile.languages).not_to include(subject)
      expect(reloaded_facsimile.languages).to include(language)
      expect(old_language_id).not_to eq(language.id)
    end
  end
end
