require "json"
require "quickblox_api/version"
require "hmac-sha1"
require "rest-client"
require "addressable/uri"
require "quickblox_api/auth"
require "quickblox_api/config"
require "quickblox_api/session"

module QuickbloxApi
  extend Config
  extend Session

  module Request
    def self.try &block
      begin
        block.call
      rescue Exception => e
        raise e unless e.code == 401
        ::QuickbloxApi.expire_session
        self.try(&block)
      end
    end
  end

  def self.get_user_by_external_id(external_id, options={})
    get_request "https://#{self.domain}/users/external/#{external_id}.json"
  end

  def self.user_sign_up(user_attributes, options={})
    post_request "https://#{self.domain}/users.json", user_attributes
  end

  def self.get_request(url)
    Request.try { RestClient.get url, token_header }
  end

  def self.post_request(url, params={})
    Request.try { RestClient.post url, params, token_header }
  end

  private
    def self.token_header
      { "QB-Token" => self.session_token }
    end
end

