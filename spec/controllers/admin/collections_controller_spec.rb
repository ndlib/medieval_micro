require 'rails_helper'

describe Admin::CollectionsController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:name) { "ABC Collection" }

  describe "#index" do
    before do
      @collection = Collection.new(name: name)
      @collection.save
      sign_in(user)
    end

    it 'assigns @collection' do
      get :index
      expect(assigns(:collections)).to eq([@collection])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:collection){ Collection.new(name: name) }
    before do
      collection.save
    end

    it 'should not render the #show view' do
      get :show, id: collection
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: collection
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "collection" =>{ "name"=> "ABC Collection" } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Collection.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Collection.count}.by(1)
        expect(response).to redirect_to admin_collections_path
      end
    end
  end
  describe "#destroy" do
    let(:collection) { Collection.new(name: name) }
    before do
      collection.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: collection.id
        }.not_to change{Collection.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: collection.id
        }.to change{Collection.count}.by(-1)
        expect(response).to redirect_to admin_collections_path
      end
    end

  end
  describe "#update" do

    let(:collection) { Collection.new(name: 'ABC Collection') }
    before do
      collection.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        expect(collection.name).to eq('ABC Collection')
        sign_in(user)

        put :update, id: collection.id, collection: { name: "XYZ Collection" }
        expect(collection.reload.name).to eq('ABC Collection')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(collection.name).to eq('ABC Collection')
        put :update, id: collection.id, collection: { name: "XYZ Collection" }
        expect(collection.reload.name).to eq('XYZ Collection')
        expect(response).to redirect_to admin_collections_path
      end
    end
  end
end
