# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'json'
require 'shipengine_rb/middleware/raise_http_exception'
require 'shipengine_rb/utils/request_id'
require 'shipengine_rb/utils/user_agent'

module ShipEngineRb
  class InternalClient
    attr_reader :configuration

    # @param [::ShipEngineRb::Configuration] configuration
    def initialize(configuration)
      @configuration = configuration
    end

    def get(path, options = {}, config = {})
      request(:get, path, options, config)
    end

    def post(path, options = {}, config = {})
      request(:post, path, options, config)
    end

    def put(path, options = {}, config = {})
      request(:put, path, options, config)
    end

    def delete(path, options = {}, config = {})
      request(:delete, path, options, config)
    end

    def patch(path, options = {}, config = {})
      request(:patch, path, options, config)
    end

    private

    IDEMPOTENT_METHODS = %i[delete get head options put].freeze
    private_constant :IDEMPOTENT_METHODS

    def create_connection(config)
      retries = config.retries
      base_url = config.base_url
      api_key = config.api_key
      timeout = config.timeout

      Faraday.new(url: base_url) do |conn|
        conn.headers = {
          'API-Key' => api_key,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'User-Agent' => Utils::UserAgent.new.to_s
        }

        conn.options.timeout = timeout / 1000
        conn.request(:json)
        conn.request(:retry, {
                       max: retries,
                       retry_statuses: [429],
                       methods: IDEMPOTENT_METHODS + [:post],
                       exceptions: [ShipEngineRb::Exceptions::RateLimitError],
                       retry_block: proc { |env:, **_kwargs|
                         env.request_headers['Retries'] = config.retries.to_s
                       }
                     })

        conn.use(ShipEngineRb::Middleware::RaiseHttpException)
        conn.response(:json, content_type: //)
      end
    end

    def request(method, path, options, config)
      config_with_overrides = @configuration.merge(config)

      create_connection(config_with_overrides).send(method) do |request|
        case method
        when :get, :delete
          request.url(path, options)
        when :post, :put, :patch
          request.path = path
          request.body = options unless options.empty?
        end
      end
    end
  end
end
