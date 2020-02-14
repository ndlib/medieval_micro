module Admin
  # Responsible for exposing Okta authentication behavior
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def oktaoauth
      username = request.env["omniauth.auth"].extra.raw_info.netid
      @user = User.find_or_create_user_by_username(username)
      sign_in_and_redirect @user, event: :authentication
    end
  end
end
