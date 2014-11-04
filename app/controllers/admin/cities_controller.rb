class Admin::CitiesController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource
  skip_load_resource :only => :index

  layout 'admin'

  def index
    @cities = City.with_name_like(params[:q]).page(params[:page])
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @city.save
        format.html { redirect_to(admin_cities_path, :notice => 'City was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(admin_cities_path, :notice => 'City was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(admin_cities_path) }
    end
  end

end
