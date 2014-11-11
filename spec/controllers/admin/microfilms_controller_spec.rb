require 'rails_helper'

describe Admin::MicrofilmsController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:mss_name) { "ABC Microfilm" }

  describe "#index" do
    before do
      @microfilm = Microfilm.new(mss_name: mss_name, shelf_mark: 'A110')
      @microfilm.save
      sign_in(user)
    end

    it 'assigns @microfilm' do
      get :index
      expect(assigns(:microfilms)).to eq([@microfilm])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:microfilm){ Microfilm.new(mss_name: mss_name, shelf_mark: 'A110') }
    before do
      microfilm.save
    end

    it 'should not render the #show view' do
      get :show, id: microfilm
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: microfilm
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:params) { { "microfilm" =>{ "mss_name"=> "ABC Microfilm", "shelf_mark" => 'A110' } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{Microfilm.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{Microfilm.count}.by(1)
      end
    end
  end
  describe "#destroy" do
    let(:microfilm) { Microfilm.new(mss_name: mss_name, shelf_mark: 'A110') }
    before do
      microfilm.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: microfilm.id
        }.not_to change{Microfilm.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: microfilm.id
        }.to change{Microfilm.count}.by(-1)
        expect(response).to redirect_to admin_microfilms_path
      end
    end

  end
  describe "#update" do

    let(:microfilm) { Microfilm.new(mss_name: 'ABC Microfilm', shelf_mark: 'A110') }
    before do
      microfilm.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        expect(microfilm.mss_name).to eq('ABC Microfilm')
        sign_in(user)

        put :update, id: microfilm.id, microfilm: { mss_name: "XYZ Microfilm" }
        expect(microfilm.reload.mss_name).to eq('ABC Microfilm')
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(microfilm.mss_name).to eq('ABC Microfilm')
        put :update, id: microfilm.id, microfilm: { mss_name: "XYZ Microfilm" }
        expect(microfilm.reload.mss_name).to eq('XYZ Microfilm')
        expect(response).to redirect_to admin_microfilm_path(microfilm)
      end
    end
  end
end
