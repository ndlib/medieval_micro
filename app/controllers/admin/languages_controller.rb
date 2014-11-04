class Admin::LanguagesController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource
  skip_load_resource :only => :index

  layout 'admin'

  def index
    @languages = Language.with_name_like(params[:q]).page(params[:page])
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @language.save
        format.html { redirect_to(admin_languages_path, :notice => 'Language was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @language.update_attributes(params[:language])
        format.html { redirect_to(admin_languages_path, :notice => 'Language was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @language.destroy

    respond_to do |format|
      format.html { redirect_to(admin_languages_path) }
    end
  end

end
