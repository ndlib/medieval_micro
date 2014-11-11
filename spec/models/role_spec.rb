require 'rails_helper'

describe Role do
  subject{ Role.find_or_create_by_name('manager') }
  let(:user) { User.create_user_with_username('user1') }

  it 'should have created role' do
    expect(subject).to be_a Role
    expect(subject.id).not_to be_nil
  end

  it 'should return usernames associated with it' do
    expect(subject.usernames).to be_empty
    expect(user.roles).to be_empty

    user.roles << subject
    user.save

    expect( subject.reload.usernames ).to include( user.username )
  end
end
