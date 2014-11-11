require 'rails_helper'

describe Collection do
  subject{ Collection.new(name: 'Collection Title') }
  before do
    subject.save
  end
  it 'should create a colleciton' do
    expect(subject).to be_a Collection
    expect(subject.id).not_to be_nil
  end
end
