class Admin::CountriesController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource
  skip_load_resource :only => :index

  layout 'admin'

  def index
    @countries = Country.with_name_like(params[:q]).page(params[:page])
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @country.save
        format.html { redirect_to(admin_countries_path, :notice => 'A new country of origin was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @country.update_attributes(params[:country])
        format.html { redirect_to(admin_countries_path, :notice => 'A country of origin was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @country.destroy

    respond_to do |format|
      format.html { redirect_to(admin_countries_path) }
    end
  end

end
