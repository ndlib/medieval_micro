require 'rails_helper'

describe Admin::RolesController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:name) { "Some Role" }

  describe "#index" do
    before do
      @role = Role.find_or_create_by_name(name)
      sign_in(user)
    end

    it 'assigns @role' do
      get :index
      expect(assigns(:roles)).to eq([admin_role, @role])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:role){ Role.find_or_create_by_name(name) }

    it 'should not render the #show view' do
      get :show, id: role
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: role
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "role" =>{ "name"=>"Some Other Role" } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Role.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Role.count}.by(1)
      end
    end
  end
  describe "#destroy" do
    let(:role){ Role.find_or_create_by_name(name) }

    before do
      role
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: role.id
        }.not_to change{Role.count}.from(2)
      end
    end

    context 'logged in as admin' do
      it 'should not be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: role.id
        }.not_to change{Role.count}.from(2)
      end
    end

  end
  describe "#update" do

    let(:role) { Role.find_or_create_by_name('Some Role') }

    context 'logged in as user' do
      it 'should not be successful' do
        expect(role.name).to eq('Some Role')
        sign_in(user)

        put :update, id: role.id, role: { name: "Some Other Role" }
        expect(role.reload.name).to eq('Some Role')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(role.name).to eq('Some Role')
        put :update, id: role.id, role: { name: "Some Other Role" }
        expect(role.reload.name).to eq('Some Other Role')
        expect(response).to redirect_to admin_role_path(role.id)
      end
    end
  end
end
