module QuickbloxApi
  module Config
    def config=(hash)
      @config = hash.merge(domain: "api.quickblox.com")
    end

    def config
      assert_config_presence
      @config
    end

    def assert_config_presence
      if @config.nil? || @config.empty?
        raise "No configuration set"
      end
    end

    def domain
      self.config[:domain]
    end

    def auth_retry_count
      self.config[:auth_retry_count] || 3
    end
  end
end
