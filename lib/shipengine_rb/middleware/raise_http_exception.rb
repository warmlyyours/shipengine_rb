# frozen_string_literal: true

require 'faraday'
require 'json'

module ShipEngineRb
  module Middleware
    class RaiseHttpException < Faraday::Middleware
      def on_complete(env)
        case env[:status].to_i
        when 400, 401, 404, 500, 502, 503, 504
          raise ShipEngineRb::Exceptions::ShipEngineError.new(
            message: error_body(env[:body]),
            source: error_source(env[:body]),
            type: error_type(env[:body]),
            code: error_code(env[:body]),
            request_id: parse_body(env[:body])&.dig('request_id'),
            url: env[:url].to_s
          )
        when 429
          raise ShipEngineRb::Exceptions::RateLimitError.new(
            retries: env.request_headers['Retries'].to_i,
            source: error_source(env[:body]),
            request_id: parse_body(env[:body])&.dig('request_id')
          )
        end
      end

      private

      def parse_body(body)
        return nil if body.nil? || (body.is_a?(String) && body.empty?)

        body.is_a?(String) ? ::JSON.parse(body) : body
      end

      def error_body(body)
        parsed = parse_body(body)
        parsed&.dig('errors', 0, 'message')
      end

      def error_source(body)
        parsed = parse_body(body)
        parsed&.dig('errors', 0, 'error_source')
      end

      def error_type(body)
        parsed = parse_body(body)
        parsed&.dig('errors', 0, 'error_type')
      end

      def error_code(body)
        parsed = parse_body(body)
        parsed&.dig('errors', 0, 'error_code')
      end
    end
  end
end
