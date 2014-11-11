require 'rails_helper'

describe Microfilm do

  subject{ Microfilm.new(mss_name: 'Test Microfilm', shelf_mark: 'A110') }

  before do
    subject.save
  end

  it 'should create a microfilm' do
    expect(subject).to be_a Microfilm
    expect(subject.id).not_to be_nil
    expect(subject.solr_id).to eq("microfilm-#{subject.id}")
  end
end
