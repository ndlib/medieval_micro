require 'rails_helper'

describe Admin::LocationsController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:name) { "200 Abc St." }

  describe "#index" do
    before do
      @location = Location.new(name: name)
      @location.save
      sign_in(user)
    end

    it 'assigns @location' do
      get :index
      expect(assigns(:locations)).to eq([@location])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:location){ Location.new(name: name) }
    before do
      location.save
    end

    it 'should not render the #show view' do
      get :show, id: location
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: location
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "location" =>{ "name"=>"200 Abc St." } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Location.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Location.count}.by(1)
        expect(response).to redirect_to admin_locations_path
      end
    end
  end
  describe "#destroy" do
    let(:location) { Location.new(name: name) }
    before do
      location.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: location.id
        }.not_to change{Location.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: location.id
        }.to change{Location.count}.by(-1)
        expect(response).to redirect_to admin_locations_path
      end
    end

  end
  describe "#update" do

    let(:location) { Location.new(name: '200 Abc St.') }
    before do
      location.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        expect(location.name).to eq('200 Abc St.')
        sign_in(user)

        put :update, id: location.id, location: { name: "1000 Xyz St." }
        expect(location.reload.name).to eq('200 Abc St.')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(location.name).to eq('200 Abc St.')
        put :update, id: location.id, location: { name: "1000 Xyz St." }
        expect(location.reload.name).to eq('1000 Xyz St.')
        expect(response).to redirect_to admin_locations_path
      end
    end
  end
end
