class Admin::FacsimilesController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource
  skip_load_resource :only => :index

  layout 'admin'

  def index
    @facsimiles = Facsimile.page( params[:page] )
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @facsimile.save
        format.html { redirect_to(admin_facsimile_path( @facsimile ), :notice => 'Facsimile was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @facsimile.update_attributes(params[:facsimile])
        format.html { redirect_to(admin_facsimile_path( @facsimile ), :notice => 'Facsimile was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @facsimile.destroy

    respond_to do |format|
      format.html { redirect_to(admin_facsimiles_path) }
    end
  end

end
