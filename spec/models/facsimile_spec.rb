require 'rails_helper'

describe Facsimile do

  subject{ Facsimile.new(title: 'Test Facsimile', shelf_mark: 'A110') }

  before do
    subject.save
  end

  it 'should create a facsimile' do
    expect(subject).to be_a Facsimile
    expect(subject.id).not_to be_nil
    expect(subject.solr_id).to eq("facsimile-#{subject.id}")
  end
end
