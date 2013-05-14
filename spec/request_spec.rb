require 'minitest/spec'
require 'minitest/autorun'
require 'pry'

require 'quickblox_api'

describe QuickbloxApi::Request do
  let(:request) { QuickbloxApi::Request.new(auth_retry_count: 3) }

  describe "unauthorized request exhausts retry count" do
    it "raises InvalidTokenException" do
      proc do
        request.try do
          raise RestClient::ExceptionWithResponse.new(nil, 401)
        end
      end.must_raise(QuickbloxApi::InvalidTokenException)
    end

    describe "retry count" do
      before(:each) do
        begin
          request.try { raise RestClient::ExceptionWithResponse.new(nil, 401) }
        rescue QuickbloxApi::InvalidTokenException => e
          @exception = e
        end
      end
      subject { @exception.retries }

      it "returns the correct retry count" do
        subject.must_equal 3
      end
    end
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

  describe "resource not found" do
    it "raises ResourceNotFoundException" do
      proc do
        request.try do
          raise RestClient::ExceptionWithResponse.new(nil, 404)
        end
      end.must_raise(QuickbloxApi::ResourceNotFoundException)
    end
  end

  describe "other error" do
    it "raises RequestException" do
      proc do
        request.try do
          raise RestClient::ExceptionWithResponse.new(nil, 406)
        end
      end.must_raise(QuickbloxApi::RequestException)
    end
  end
end
