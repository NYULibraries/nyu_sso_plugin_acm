require 'sinatra/base'
require 'omniauth-oauth2'
require_relative 'lib/ssoauth_helper'
require "yaml"

include SsoauthHelper

sso_url="archivesspace-dev.library.nyu.edu"
sso_login_url="dev.login.library.nyu.edu"
sso_frontend_port="8480"

AppConfig[:frontend_sso_url]= "https://#{sso_url}"
AppConfig[:sso_login_url]= "https://#{sso_login_url}"

AppConfig[:ap_id]="replace_with_real_ap_id"
AppConfig[:auth_key]="replace_with_real_auth_key"

class ArchivesSpaceService < Sinatra::Base
  use Rack::Session::Cookie, :key => 'rack.session',
      :expire_after => 2592000, # In seconds
      :secret => 'archivesspace remote SSO session'

  use OmniAuth::Builder do
    provider :nyulibraries, AppConfig[:ap_id], AppConfig[:auth_key],
    client_options: {
            site: AppConfig[:sso_login_url],
            authorize_path: '/oauth/authorize'
    }
  end

end

