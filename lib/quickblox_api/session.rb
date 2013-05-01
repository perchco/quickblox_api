module QuickbloxApi
  module Session
    def session
      @session ||= Authenticator.new.authenticate
    end

    def session_token
      session["session"]["token"]
    end
  end
end
