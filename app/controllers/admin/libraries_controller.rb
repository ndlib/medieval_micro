class Admin::LibrariesController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource
  skip_load_resource :only => :index

  layout 'admin'

  def index
    @libraries = Library.with_name_like(params[:q]).page(params[:page])
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @library.save
        format.html { redirect_to(admin_libraries_path, :notice => 'Library was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @library.update_attributes(params[:library])
        format.html { redirect_to(admin_libraries_path, :notice => 'Library was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @library.destroy

    respond_to do |format|
      format.html { redirect_to(admin_libraries_path) }
    end
  end

end
