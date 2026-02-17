# frozen_string_literal: true

module ShipEngineRb
  class Configuration
    attr_accessor :api_key, :retries, :base_url, :timeout, :page_size

    def initialize(api_key:, retries: nil, timeout: nil, page_size: nil, base_url: nil)
      @api_key = api_key
      @base_url = base_url || Constants.base_url
      @retries = retries || 1
      @timeout = timeout || 60_000
      @page_size = page_size || 50
      validate
    end

    def merge(config)
      copy = clone
      copy.api_key   = config[:api_key] if config.key?(:api_key)
      copy.base_url  = config[:base_url] if config.key?(:base_url)
      copy.retries   = config[:retries] if config.key?(:retries)
      copy.timeout   = config[:timeout] if config.key?(:timeout)
      copy.page_size = config[:page_size] if config.key?(:page_size)
      copy.validate
      copy
    end

    protected

    def validate
      Utils::Validate.str('A ShipEngine API key', @api_key)
      Utils::Validate.str('Base URL', @base_url)
      Utils::Validate.non_neg_int('Retries', @retries)
      Utils::Validate.positive_int('Timeout', @timeout)
      Utils::Validate.positive_int('Page size', @page_size)
    end
  end
end
