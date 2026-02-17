# frozen_string_literal: true

module ShipEngineRb
  class Configuration
    attr_reader :api_key, :retries, :base_url, :timeout, :open_timeout, :page_size, :logger

    # @param api_key [String] Your ShipEngine API key.
    # @param retries [Integer, nil] Number of retries on 429. Defaults to 1.
    # @param timeout [Integer, nil] Total request timeout in milliseconds. Defaults to 60000.
    # @param open_timeout [Integer, nil] TCP connection timeout in milliseconds. Defaults to 10000.
    # @param page_size [Integer, nil] Default page size for list endpoints. Defaults to 50.
    # @param base_url [String, nil] API base URL. Defaults to ShipEngine production.
    # @param logger [Logger, nil] Optional logger for request/response logging.
    def initialize(api_key:, retries: nil, timeout: nil, open_timeout: nil, page_size: nil, base_url: nil, logger: nil)
      @api_key = api_key
      @base_url = base_url || Constants.base_url
      @retries = retries || 1
      @timeout = timeout || 60_000
      @open_timeout = open_timeout || 10_000
      @page_size = page_size || 50
      @logger = logger
      validate!
      freeze
    end

    # Returns a new Configuration with the given overrides applied.
    # The original configuration is not modified (it's frozen).
    #
    # @param overrides [Hash] Keys to override (:api_key, :retries, :timeout, etc.)
    # @return [Configuration] A new frozen Configuration instance.
    def merge(overrides)
      return self if overrides.nil? || overrides.empty?

      self.class.new(
        api_key: overrides.fetch(:api_key, @api_key),
        base_url: overrides.fetch(:base_url, @base_url),
        retries: overrides.fetch(:retries, @retries),
        timeout: overrides.fetch(:timeout, @timeout),
        open_timeout: overrides.fetch(:open_timeout, @open_timeout),
        page_size: overrides.fetch(:page_size, @page_size),
        logger: overrides.fetch(:logger, @logger)
      )
    end

    private

    def validate!
      Utils::Validate.str('A ShipEngine API key', @api_key)
      Utils::Validate.str('Base URL', @base_url)
      Utils::Validate.non_neg_int('Retries', @retries)
      Utils::Validate.positive_int('Timeout', @timeout)
      Utils::Validate.positive_int('Open timeout', @open_timeout)
      Utils::Validate.positive_int('Page size', @page_size)
    end
  end
end
