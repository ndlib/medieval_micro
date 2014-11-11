require 'rails_helper'

describe Admin::DateRangesController do
  let(:user) { User.create_user_with_username(:user1) }
  let(:admin_user) { User.create_user_with_username(:admin_user) }
  let(:admin_role) { Role.find_or_create_by_name('administrators') }

  before do
    admin_user.roles << admin_role
    admin_user.save
  end

  let(:code) { "1" }

  describe "#index" do
    before do
      @date_range = DateRange.create_date_range_with_code(code)
      sign_in(user)
    end

    it 'assigns @date_range' do
      get :index
      expect(assigns(:date_ranges)).to eq([@date_range])
    end

    it 'should render #index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let(:date_range){ DateRange.create_date_range_with_code(code) }

    it 'should not render the #show view' do
      get :show, id: date_range
      response.should_not render_template :show
    end

    it 'renders the #show view' do
      sign_in(user)
      get :show, id: date_range
      response.should render_template :show
    end
  end

  describe "#create" do

    let(:start_date) { "1800-01-01" }
    let(:end_date) { "1900-01-01" }

    let(:params) { { "date_range" =>{ "code" => "1", "start_date"=> start_date, "end_date" => end_date } } }

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          post :create, params
        }.not_to change{DateRange.count}.from(0)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          post :create, params
        }.to change{DateRange.count}.by(1)
      end
    end
  end
  describe "#destroy" do
    let(:date_range){ DateRange.create_date_range_with_code(code) }

    before do
      date_range
    end

    context 'logged in as user' do
      it 'should not be successful' do
        sign_in(user)

        expect{
          delete :destroy, id: date_range.id
        }.not_to change{DateRange.count}.from(1)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect{
          delete :destroy, id: date_range.id
        }.to change{DateRange.count}.by(-1)
        expect(response).to redirect_to admin_date_ranges_path
      end
    end

  end
  describe "#update" do

    let(:date_range) { DateRange.create_date_range_with_code('1') }
    let(:start_date) { "1800-01-01" }
    let(:end_date) { "1900-01-01" }

    let(:params) { { "date_range" =>{ "code" => "1", "start_date"=> start_date, "end_date" => end_date } } }

    before do
      date_range.start_date = start_date
      date_range.end_date = end_date
      date_range.save
    end

    context 'logged in as user' do
      it 'should not be successful' do
        expect(date_range.end_date.to_s).to eq(end_date)
        sign_in(user)

        put :update, id: date_range.id, date_range: { end_date: "1899-12-31" }
        expect(date_range.reload.end_date.to_s).to eq(end_date)
      end
    end

    context 'logged in as admin' do
      it 'should be successful' do
        sign_in(admin_user)

        expect(date_range.end_date.to_s).to eq(end_date)
        put :update, id: date_range.id, date_range: { end_date: "1899-12-31" }
        expect(date_range.reload.end_date.to_s).to eq('1899-12-31')
        expect(response).to redirect_to admin_date_range_path(date_range.id)
      end
    end
  end
end
