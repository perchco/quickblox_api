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

  def self.get_user_by_external_id(external_id, options={})
    get_request "https://#{self.domain}/users/external/#{external_id}.json"
  end

  def self.get_request(url)
    response = RestClient.get url, "QB-Token" => self.session_token
    JSON.parse(response)
  end
end

