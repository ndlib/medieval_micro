require 'rails_helper'

describe Admin::CountriesController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:name) { "United States of America" }

  describe "#index" do
    before do
      @country = Country.create_with_name(name)
      sign_in(user)
    end

    it 'assigns @country' do
      get :index
      expect(assigns(:countries)).to eq([@country])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:country){ Country.create_with_name(name) }

    it 'should not render the #show view' do
      get :show, id: country
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: country
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "country" =>{ "name"=>"Canada" } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Country.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Country.count}.by(1)
        expect(response).to redirect_to admin_countries_path
      end
    end
  end
  describe "#destroy" do
    let(:country){ Country.create_with_name(name) }

    before do
      country
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: country.id
        }.not_to change{Country.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: country.id
        }.to change{Country.count}.by(-1)
        expect(response).to redirect_to admin_countries_path
      end
    end

  end
  describe "#update" do

    let(:country) { Country.create_with_name('Canada') }

    context 'logged in as user' do
      it 'should not be successful' do
        expect(country.name).to eq('Canada')
        sign_in(user)

        put :update, id: country.id, country: { name: "USA" }
        expect(country.reload.name).to eq('Canada')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(country.name).to eq('Canada')
        put :update, id: country.id, country: { name: "USA" }
        expect(country.reload.name).to eq('USA')
        expect(response).to redirect_to admin_countries_path
      end
    end
  end
end
