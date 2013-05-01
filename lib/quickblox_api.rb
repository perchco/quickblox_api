require "json"
require "quickblox_api/version"
require "hmac-sha1"
require "rest-client"
require "addressable/uri"
require "quickblox_api/auth"
require "quickblox_api/config"

module QuickbloxApi
    extend Config

    def self.get_user_by_external_id(external_id, token)
    end
end

