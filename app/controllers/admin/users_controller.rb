class Admin::UsersController < ApplicationController
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
    build_nested_models
  end

  def create
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(admin_users_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        # TODO accepts_nested_attributes_for stopped working for an unknown reason. That should be fixed.
        # As a stopgap the following re-implements a subset of the functionality provided by that method.
        default_attribute_hash = params[:user][:default_attribute_values_attributes]
        @user.default_attribute_values.each do |attribute_value|
          default_attribute_hash.each_value do |updated_attribute|
            attribute_value.update_attribute(:value, updated_attribute[:value]) if updated_attribute[:id].to_i == attribute_value.id
          end
        end
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(root_url) }
      else
        format.html { render :action => :edit }
      end
    end
  end

  def destroy
    User.find(params[:id]).delete
    respond_to do |format|
      format.html { redirect_to(admin_users_path) }
    end
  end

  private

  def build_nested_models
    DefaultAttributeType.all.each do |type|
      @user.default_attribute_values.build(:default_attribute_type_id => type.id) unless @user.default_attribute_values.where( :default_attribute_type_id => type.id ).any?
    end
  end

end
