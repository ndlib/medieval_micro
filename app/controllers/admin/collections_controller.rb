class Admin::CollectionsController < ApplicationController
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
      if @collection.save
        format.html { redirect_to(admin_collections_path, :notice => 'Collection was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @collection.update_attributes(params[:collection])
        format.html { redirect_to(admin_collections_path, :notice => 'Collection was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @collection.destroy

    respond_to do |format|
      format.html { redirect_to(admin_collections_path) }
    end
  end

end
