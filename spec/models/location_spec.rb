require 'rails_helper'

describe Location do
  subject{ Location.new(name: 'Hesburgh Location') }
  before do
    subject.save
  end
  it 'should create a location' do
    expect(subject).to be_a Location
    expect(subject.id).not_to be_nil
  end
end
