class Admin::LocationsController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource

  layout 'admin'

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @location.save
        format.html { redirect_to(admin_locations_path, :notice => 'Location was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(admin_locations_path, :notice => 'Location was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(admin_locations_path) }
    end
  end

end
