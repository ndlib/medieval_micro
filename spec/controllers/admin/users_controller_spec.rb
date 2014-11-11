require 'rails_helper'

describe Admin::UsersController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end


  describe "#index" do
    let(:username) { "some_user_1" }
    before do
      @user = User.create_user_with_username(username)
      @user.save
      sign_in(user)
    end

    it 'assigns @user' do
      get :index
      expect(assigns(:users)).to eq([admin_user, @user, user])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:username) { "some_user_2" }
    let(:another_user){ User.create_user_with_username(username) }

    it 'should not render the #show view' do
      get :show, id: another_user
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: another_user
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "user" =>{ "username"=>"some_other_user" } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{User.count}.from(2)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{User.count}.by(1)
        expect(response).to redirect_to admin_users_path
      end
    end
  end
  describe "#destroy" do
    let(:username) { "some_user_3" }
    let(:new_user){ User.create_user_with_username(username) }

    before do
      new_user
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: new_user.id
        }.not_to change{User.count}.from(3)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: new_user.id
        }.to change{User.count}.by(-1)
        expect(response).to redirect_to admin_users_path
      end
    end

  end
  describe "#update" do

    let(:user) { User.create_user_with_username('new_user_2') }

    context 'logged in as user' do
      it 'Cannot edit username of the user' do
        expect(user.username).to eq('new_user_2')
        sign_in(user)

        put :update, id: user.id, user: { username: "new_user_3" }
        expect(user.reload.username).to eq('new_user_2')
      end
    end

    context 'logged in as admin' do
      it 'Cannot edit username of the user' do
        sign_in(admin_user)

        expect(user.username).to eq('new_user_2')
        put :update, id: user.id, user: { name: "new_user_3" }
        expect(user.reload.username).to eq('new_user_2')
        expect(response).to redirect_to root_path
      end
    end
  end
end
