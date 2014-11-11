require 'rails_helper'

describe Library do
  subject{ Library.create_with_name('Hesburgh Library') }
  it 'should create a library' do
    expect(subject).to be_a Library
    expect(subject.id).not_to be_nil
  end

  context 'find or create library' do
    it 'should find a library' do
      subject
      library = Library.find_or_create_by_name('Hesburgh Library')
      expect(library.id).to eq(subject.id)
    end

    it 'should create a library' do
      subject
      library = Library.find_or_create_by_name('Branch Library')
      expect(library.id).not_to eq(subject.id)
    end
  end
end
