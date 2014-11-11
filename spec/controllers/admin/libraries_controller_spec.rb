require 'rails_helper'

describe Admin::LibrariesController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:name) { "ND Library" }

  describe "#index" do
    before do
      @library = Library.create_with_name(name)
      sign_in(user)
    end

    it 'assigns @library' do
      get :index
      expect(assigns(:libraries)).to eq([@library])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:library){ Library.create_with_name(name) }

    it 'should not render the #show view' do
      get :show, id: library
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: library
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "library" =>{ "name"=>"ND Library" } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Library.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Library.count}.by(1)
        expect(response).to redirect_to admin_libraries_path
      end
    end
  end
  describe "#destroy" do
    let(:library){ Library.create_with_name(name) }

    before do
      library
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: library.id
        }.not_to change{Library.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: library.id
        }.to change{Library.count}.by(-1)
        expect(response).to redirect_to admin_libraries_path
      end
    end

  end
  describe "#update" do

    let(:library) { Library.create_with_name('ND Library') }

    context 'logged in as user' do
      it 'should not be successful' do
        expect(library.name).to eq('ND Library')
        sign_in(user)

        put :update, id: library.id, library: { name: "Hesburgh Library" }
        expect(library.reload.name).to eq('ND Library')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(library.name).to eq('ND Library')
        put :update, id: library.id, library: { name: "Hesburgh Library" }
        expect(library.reload.name).to eq('Hesburgh Library')
        expect(response).to redirect_to admin_libraries_path
      end
    end
  end
end
