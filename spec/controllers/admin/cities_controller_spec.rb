require 'rails_helper'

describe Admin::CitiesController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:name) { "South Bend" }

  describe "#index" do
    before do
      @city = City.create_with_name(name)
      sign_in(user)
    end

    it 'assigns @city' do
      get :index
      expect(assigns(:cities)).to eq([@city])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:city){ City.create_with_name(name) }

    it 'should not render the #show view' do
      get :show, id: city
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: city
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "city" =>{ "name"=>"Chicago" } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{City.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{City.count}.by(1)
        expect(response).to redirect_to admin_cities_path
      end
    end
  end
  describe "#destroy" do
    let(:city){ City.create_with_name(name) }

    before do
      city
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: city.id
        }.not_to change{City.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: city.id
        }.to change{City.count}.by(-1)
        expect(response).to redirect_to admin_cities_path
      end
    end

  end
  describe "#update" do

    let(:city) { City.create_with_name('New York') }

    context 'logged in as user' do
      it 'should not be successful' do
        expect(city.name).to eq('New York')
        sign_in(user)

        put :update, id: city.id, city: { name: "Chicago" }
        expect(city.reload.name).to eq('New York')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(city.name).to eq('New York')
        put :update, id: city.id, city: { name: "Chicago" }
        expect(city.reload.name).to eq('Chicago')
        expect(response).to redirect_to admin_cities_path
      end
    end
  end
end
