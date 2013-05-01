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

  RestClient.add_before_execution_proc do |req, params|
    params[:headers]["QB-Token"] = self.session_token unless req.path.include?("session")
  end

  def self.get_user_by_external_id(external_id, options={})
    response = RestClient.get "https://#{self.domain}/users/external/#{external_id}.json"
    JSON.parse(response)
  end
end

