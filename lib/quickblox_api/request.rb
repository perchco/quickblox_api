require 'forwardable'

module QuickbloxApi

  class RequestException < StandardError
    extend Forwardable

    attr_reader :response

    def_delegator :@response, :code

    def initialize(response, code=nil)
      @response = response
      @code = code || response.code
    end

    def errors
      response["errors"]
    end
  end

  class InvalidTokenException < RequestException
    attr_reader :retries
    def initialize(response, code, retries)
      super(response, code)
      @retries = retries
    end
  end

  class UnprocessableRequestException < RequestException; end
  class ResourceNotFoundException < RequestException; end

  class Request
    attr_accessor :tries
    attr_reader :auth_retry_count

    def initialize(options={})
      @auth_retry_count = options.fetch(:auth_retry_count, 3)
      @tries = 0
    end

    def try(&block)
      begin
        self.tries += 1
        block.call
      rescue RestClient::ExceptionWithResponse => e
        if e.http_code == 401
          if retry_request?
            ::QuickbloxApi.expire_session
            self.try(&block)
          end
        end
        handle_error(e.response, e.http_code)
      end
    end

    private
      def retry_request?
        self.tries < self.auth_retry_count
      end

      def handle_error(response, http_code)
        case http_code
        when 401
          raise InvalidTokenException.new(response, http_code, self.tries)
        when 422
          raise UnprocessableRequestException.new(response, http_code)
        when 404
          raise ResourceNotFoundException.new(response, http_code)
        else
          raise RequestException.new(response, http_code)
        end
      end
  end
end
