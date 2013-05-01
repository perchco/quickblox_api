module QuickbloxApi

  class Signature
    attr_reader :body, :auth_secret

    def initialize(auth_secret, body)
      @body, @auth_secret = body, auth_secret
    end

    def to_s
      @signature ||= create_signature
    end

    protected
      def create_signature
        @signature ||= HMAC::SHA1.hexdigest(auth_secret, body)
      end
  end

  class Authenticator
    attr_reader :token, :request_body, :domain

    def initialize(options={})
      @request_body = options.fetch(:session_request, SessionRequest.new).generate
      @domain = options.fetch(:domain, QuickbloxApi.domain)

    end

    def authenticate
      unless @token
        response = RestClient.post "https://#{domain}/session.json", request_body
        @token = JSON.parse(response)["session"]["token"]
      end
      @token
    end
  end

  class SessionRequest
    attr_reader :config
    def initialize(options={})
      @config = options.fetch(:config, QuickbloxApi.config)
      assert_config
    end

    def generate
      sign(params)
    end

    private
      def params
        @params ||= {
          application_id: config[:application_id],
          auth_key: config[:auth_key],
          timestamp: Time.now.to_i,
          nonce: rand(10000)
        }
      end

      def sign(params)
        uri = Addressable::URI.new
        uri.query_values = params
        signature = Signature.new(config[:auth_secret], uri.query)
        params.merge(signature: signature)
      end

      def assert_config
        if config.nil? || config.empty?
          raise "config needs to be defined"
        end
      end
  end
end
