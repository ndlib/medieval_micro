require 'rails_helper'

describe Admin::FacsimilesController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:title) { "ABC Facsimile" }

  describe "#index" do
    before do
      @facsimile = Facsimile.new(title: title, shelf_mark: 'A110')
      @facsimile.save
      sign_in(user)
    end

    it 'assigns @facsimile' do
      get :index
      expect(assigns(:facsimiles)).to eq([@facsimile])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:facsimile){ Facsimile.new(title: title, shelf_mark: 'A110') }
    before do
      facsimile.save
    end

    it 'should not render the #show view' do
      get :show, id: facsimile
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: facsimile
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "facsimile" =>{ "title"=> "ABC Facsimile", "shelf_mark" => 'A110' } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Facsimile.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Facsimile.count}.by(1)
      end
    end
  end
  describe "#destroy" do
    let(:facsimile) { Facsimile.new(title: title, shelf_mark: 'A110') }
    before do
      facsimile.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: facsimile.id
        }.not_to change{Facsimile.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: facsimile.id
        }.to change{Facsimile.count}.by(-1)
        expect(response).to redirect_to admin_facsimiles_path
      end
    end

  end
  describe "#update" do

    let(:facsimile) { Facsimile.new(title: 'ABC Facsimile', shelf_mark: 'A110') }
    before do
      facsimile.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        expect(facsimile.title).to eq('ABC Facsimile')
        sign_in(user)

        put :update, id: facsimile.id, facsimile: { title: "XYZ Facsimile" }
        expect(facsimile.reload.title).to eq('ABC Facsimile')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(facsimile.title).to eq('ABC Facsimile')
        put :update, id: facsimile.id, facsimile: { title: "XYZ Facsimile" }
        expect(facsimile.reload.title).to eq('XYZ Facsimile')
        expect(response).to redirect_to admin_facsimile_path(facsimile)
      end
    end
  end
end
