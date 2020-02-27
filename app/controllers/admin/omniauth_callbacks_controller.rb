module Admin
  # Responsible for exposing Okta authentication behavior
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def oktaoauth
      raw_info = request.env["omniauth.auth"].extra.raw_info
      @user = User.find_or_create_user_by_okta_rawinfo(raw_info)
      sign_in_and_redirect @user, event: :authentication
    end
  end
end
