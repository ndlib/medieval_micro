require 'rails_helper'

describe Admin::LanguagesController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:name) { "English" }

  describe "#index" do
    before do
      @language = Language.create_with_name(name)
      sign_in(user)
    end

    it 'assigns @language' do
      get :index
      expect(assigns(:languages)).to eq([@language])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:language){ Language.create_with_name(name) }

    it 'should not render the #show view' do
      get :show, id: language
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: language
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "language" =>{ "name"=>"English" } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Language.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Language.count}.by(1)
        expect(response).to redirect_to admin_languages_path
      end
    end
  end
  describe "#destroy" do
    let(:language){ Language.create_with_name(name) }

    before do
      language
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: language.id
        }.not_to change{Language.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: language.id
        }.to change{Language.count}.by(-1)
        expect(response).to redirect_to admin_languages_path
      end
    end

  end
  describe "#update" do

    let(:language) { Language.create_with_name('Spanish') }

    context 'logged in as user' do
      it 'should not be successful' do
        expect(language.name).to eq('Spanish')
        sign_in(user)

        put :update, id: language.id, language: { name: "English" }
        expect(language.reload.name).to eq('Spanish')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(language.name).to eq('Spanish')
        put :update, id: language.id, language: { name: "English" }
        expect(language.reload.name).to eq('English')
        expect(response).to redirect_to admin_languages_path
      end
    end
  end
end
