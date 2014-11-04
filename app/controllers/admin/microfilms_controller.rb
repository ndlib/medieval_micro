class Admin::MicrofilmsController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource
  skip_load_resource :only => :index

  layout 'admin'

  def index
    if params[:collection].blank?
      @microfilms = Microfilm.with_shelf_mark( params[:q] ).page( params[:page] )
    else
      @microfilms = Collection.find( params[:collection] ).microfilms.with_shelf_mark( params[:q] ).page( params[:page] )
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @microfilm.save
        format.html { redirect_to(admin_microfilm_path(@microfilm), :notice => 'Microfilm was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @microfilm.update_attributes(params[:microfilm])
        format.html { redirect_to(admin_microfilm_path(@microfilm), :notice => 'Microfilm was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @microfilm.destroy

    respond_to do |format|
      format.html { redirect_to(admin_microfilms_path) }
    end
  end

end
