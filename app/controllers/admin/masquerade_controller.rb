class Admin::MasqueradeController < ApplicationController
  skip_authorization_check :only => :stop

  # GET admin/masquerade/start/:user_id
  def start
    authorize! :masquerade, current_user
    begin
      session[:user_the_masquerade] = User.find(params[:user_id]).netid
      current_ability = nil
      redirect_to admin_path
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_path
    end
  end

  # GET admin/masquerade/stop
  def stop
    session[:user_the_masquerade] = nil
    current_ability = nil
    redirect_to previous_page
  end
end
