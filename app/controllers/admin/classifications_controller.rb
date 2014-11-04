class Admin::ClassificationsController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource
  skip_load_resource :only => :index

  layout 'admin'

  def index
    @classifications = Classification.with_name_like(params[:q]).page(params[:page])
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @classification.save
        format.html { redirect_to(admin_classifications_path, :notice => 'A new text classification was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @classification.update_attributes(params[:classification])
        format.html { redirect_to(admin_classifications_path, :notice => 'A text classification was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @classification.destroy

    respond_to do |format|
      format.html { redirect_to(admin_classifications_path) }
    end
  end

end
