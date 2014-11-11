require 'rails_helper'

describe Admin::ClassificationsController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:name) { "Some Classification" }

  describe "#index" do
    before do
      @classification = Classification.create_with_name(name)
      sign_in(user)
    end

    it 'assigns @classification' do
      get :index
      expect(assigns(:classifications)).to eq([@classification])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:classification){ Classification.create_with_name(name) }

    it 'should not render the #show view' do
      get :show, id: classification
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: classification
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "classification" =>{ "name"=>"Some Other Classification" } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Classification.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Classification.count}.by(1)
        expect(response).to redirect_to admin_classifications_path
      end
    end
  end
  describe "#destroy" do
    let(:classification){ Classification.create_with_name(name) }

    before do
      classification
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: classification.id
        }.not_to change{Classification.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: classification.id
        }.to change{Classification.count}.by(-1)
        expect(response).to redirect_to admin_classifications_path
      end
    end

  end
  describe "#update" do

    let(:classification) { Classification.create_with_name('Some Classification') }

    context 'logged in as user' do
      it 'should not be successful' do
        expect(classification.name).to eq('Some Classification')
        sign_in(user)

        put :update, id: classification.id, classification: { name: "Some Other Classification" }
        expect(classification.reload.name).to eq('Some Classification')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(classification.name).to eq('Some Classification')
        put :update, id: classification.id, classification: { name: "Some Other Classification" }
        expect(classification.reload.name).to eq('Some Other Classification')
        expect(response).to redirect_to admin_classifications_path
      end
    end
  end
end
