require 'minitest/spec'
require 'minitest/autorun'
require 'pry'

require 'quickblox_api'
require 'rest-client'

describe QuickbloxApi::Request do
  let(:request) { QuickbloxApi::Request.new(auth_retry_count: 3) }

  describe "unauthorized request exhausts retry count" do
    before do
      request.try do
        raise RestClient::ExceptionWithResponse.new(nil, 401)
      end
    end

    subject { request.tries }

    it "stops retrying at 3 times" do
      subject.must_equal(3)
    end

    describe "unprocessable request" do
      it "raises UnprocessableRequestException" do
        proc do
          request.try do
            raise RestClient::ExceptionWithResponse.new(nil, 422)
          end
        end.must_raise(QuickbloxApi::UnprocessableRequestException)
      end
    end
  end
end
