# Devise for publishers

## Migration path

- change `config/initializers/omniauth.rb` to have one line: `class OmniAuth::Strategies::Dfe < OmniAuth::Strategies::OpenIDConnect; end`
- change `config/initializers/devise.rb` on line 279 to have:

dfe_sign_in_issuer_uri    = URI(ENV.fetch("DFE_SIGN_IN_ISSUER", "example"))
dfe_sign_in_identifier    = ENV.fetch("DFE_SIGN_IN_IDENTIFIER", "example")
dfe_sign_in_secret        = ENV.fetch("DFE_SIGN_IN_SECRET", "example")
dfe_sign_in_redirect_uri  = ENV.fetch("DFE_SIGN_IN_REDIRECT_URL", "example")

dfe_sign_in_issuer_url = "#{dfe_sign_in_issuer_uri}:#{dfe_sign_in_issuer_uri.port}" if dfe_sign_in_issuer_uri.port
config.omniauth :dfe,
                name: :dfe,
                discovery: true,
                response_type: :code,
                issuer: dfe_sign_in_issuer_url,
                client_signing_alg: :RS256,
                scope: %i[openid profile email organisation],
                client_options: {
                  port: dfe_sign_in_issuer_uri.port,
                  scheme: dfe_sign_in_issuer_uri.scheme,
                  host: dfe_sign_in_issuer_uri.host,
                  identifier: dfe_sign_in_identifier,
                  secret: dfe_sign_in_secret,
                  redirect_uri: dfe_sign_in_redirect_uri,
                  authorization_endpoint: "/auth",
                  jwks_uri: "/certs",
                  userinfo_endpoint: "/me",
                }

- change `config/routes.rb` on line 55 to include:

devise_for :publishers, controllers: {
  omniauth_callbacks: "publishers/omniauth_callbacks",
  sessions: "publishers/sessions",
}

- replace `new_identifications_path` with `new_publisher_session_path`
- replace `sessions_path` with `destroy_publisher_session_path`
