# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
require 'omniauth-oktaoauth'
Devise.setup do |config|
  config.omniauth(
    :oktaoauth,
    ENV.fetch('okta_client_id'),
    ENV.fetch('okta_client_secret'),
    scope: 'openid profile email netid',
    fields: ['profile', 'email', 'netid'],
    client_options: {
            site: ENV.fetch('okta_site'),
            authorize_url: ENV.fetch('okta_auth_url'),
            token_url: ENV.fetch('okta_token_url')
    },
    redirect_uri: ENV.fetch('okta_redirect_uri'),
    auth_server_id: ENV.fetch('okta_auth_server_id'),
    issuer: ENV.fetch('okta_site'),
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
