# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
require 'omniauth-oktaoauth'
Devise.setup do |config|
  config.omniauth(
    :oktaoauth,
    Figaro.env.okta_client_id!,
    Figaro.env.okta_client_secret!,
    scope: 'openid profile email netid',
    fields: ['profile', 'email', 'netid'],
    client_options: {
            site: Figaro.env.okta_site!,
            authorize_url: File.join(Figaro.env.okta_site!, "oauth2", Figaro.env.okta_auth_server_id!, "v1/authorize"),
            token_url: File.join(Figaro.env.okta_site!, "oauth2", Figaro.env.okta_auth_server_id!, "v1/token")
    },
    redirect_uri: Figaro.env.okta_redirect_uri!,
    auth_server_id: Figaro.env.okta_auth_server_id!,
    issuer: Figaro.env.okta_site!,
    strategy_class: OmniAuth::Strategies::Oktaoauth
  )

  config.case_insensitive_keys = [ :username ]
  config.strip_whitespace_keys = [ :username ]
  config.mailer_sender = 'noreply@nd.edu'
  require 'devise/orm/active_record'
  config.skip_session_storage = [:http_auth]
  config.expire_all_remember_me_on_sign_out = true
  config.sign_out_via = :delete
end
