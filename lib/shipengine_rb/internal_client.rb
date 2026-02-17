# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'faraday/http'
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
      @connection = build_connection(configuration)
    end

    def get(path, params = {}, config = {})
      request(:get, path, params, config)
    end

    def post(path, params = {}, config = {})
      request(:post, path, params, config)
    end

    def put(path, params = {}, config = {})
      request(:put, path, params, config)
    end

    def delete(path, params = {}, config = {})
      request(:delete, path, params, config)
    end

    def patch(path, params = {}, config = {})
      request(:patch, path, params, config)
    end

    private

    IDEMPOTENT_METHODS = %i[delete get head options put].freeze
    REQUEST_KEYS = %i[idempotency_key].freeze
    private_constant :IDEMPOTENT_METHODS, :REQUEST_KEYS

    def build_connection(config)
      Faraday.new(url: config.base_url) do |conn|
        conn.headers = {
          'API-Key' => config.api_key,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'User-Agent' => Utils::UserAgent.new.to_s
        }

        conn.options.timeout = config.timeout / 1000
        conn.options.open_timeout = config.open_timeout / 1000

        conn.request(:json)
        conn.request(:retry, {
                       max: config.retries,
                       retry_statuses: [429],
                       methods: IDEMPOTENT_METHODS + [:post],
                       exceptions: [ShipEngineRb::Exceptions::RateLimitError],
                       retry_block: proc { |env:, **_kwargs|
                         env.request_headers['Retries'] = config.retries.to_s
                       }
                     })

        conn.use(ShipEngineRb::Middleware::RaiseHttpException)
        conn.response(:json, content_type: //, parser_options: { symbolize_names: true })
        conn.response(:logger, config.logger, headers: false, bodies: false) if config.logger

        conn.adapter :http
      end
    end

    def request(method, path, params, config)
      idempotency_key = config[:idempotency_key] if config.is_a?(Hash)
      config_overrides = config.is_a?(Hash) ? config.except(*REQUEST_KEYS) : config

      conn = if config_overrides.nil? || config_overrides.empty?
               @connection
             else
               build_connection(@configuration.merge(config_overrides))
             end

      response = conn.send(method) do |req|
        req.headers['Idempotency-Key'] = idempotency_key if idempotency_key

        case method
        when :get, :delete
          req.url(path, params)
        when :post, :put, :patch
          req.path = path
          req.body = params unless params.empty?
        end
      end

      response.body
    end
  end
end
