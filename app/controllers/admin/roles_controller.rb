class Admin::RolesController < ApplicationController
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
      if @role.save
        format.html { redirect_to(admin_role_path(@role), :notice => 'Role was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to(admin_role_path(@role), :notice => 'Role was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(admin_roles_path) }
    end
  end

end
