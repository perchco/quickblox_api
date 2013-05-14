require "json"
require "quickblox_api/version"
require "hmac-sha1"
require "rest-client"
require "addressable/uri"
require "quickblox_api/auth"
require "quickblox_api/config"
require "quickblox_api/session"
require "quickblox_api/request"

module QuickbloxApi
  extend Config
  extend Session

  def self.get_user_by_login(login, options={})
    get_request "https://#{self.domain}/users/by_login.json?login=#{login}"
  end

  def self.get_user_by_external_id(external_id, options={})
    get_request "https://#{self.domain}/users/external/#{external_id}.json"
  end

  def self.user_sign_up(user_attributes, options={})
    post_request "https://#{self.domain}/users.json", user_attributes
  end

  def self.get_request(url)
    new_request { RestClient.get(url, token_header) }
  end

  def self.post_request(url, params={})
    new_request { RestClient.post(url, params, token_header) }
  end

  private
    def self.new_request &block
      Request.new.try(&block)
    end

    def self.token_header
      { "QB-Token" => self.session_token }
    end
end

