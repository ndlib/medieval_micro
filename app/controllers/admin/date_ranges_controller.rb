class Admin::DateRangesController < ApplicationController
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
      if @date_range.save
        format.html { redirect_to(admin_date_range_path(@date_range), :notice => 'Date range was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @date_range.update_attributes(params[:date_range])
        format.html { redirect_to(admin_date_range_path(@date_range), :notice => 'Date range was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @date_range.destroy

    respond_to do |format|
      format.html { redirect_to(admin_date_ranges_path) }
    end
  end

end
