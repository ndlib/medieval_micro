require 'rails_helper'

describe User do
  subject { User.create_user_with_username('user1') }
 
  it 'should create a user' do
    expect(subject).to be_a User
    expect(subject.id).not_to be_nil

    subject.should respond_to :roles
    subject.to_s.should == 'user1'
  end

  context 'find or create user' do
    it 'should find a user' do
      subject
      user = User.find_or_create_by_username('user1')
      expect(user.id).to eq(subject.id)
    end

    it 'should create a user' do
      subject
      user = User.find_or_create_by_username('user2')
      expect(user.id).not_to eq(subject.id)
    end
  end
end

