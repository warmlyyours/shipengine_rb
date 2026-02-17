# frozen_string_literal: true

require 'faraday'
require 'json'

module ShipEngineRb
  module Middleware
    class RaiseHttpException < Faraday::Middleware
      def on_complete(env)
        case env[:status].to_i
        when 400, 401, 403, 404, 500, 502, 503, 504
          parsed = parse_body(env[:body])
          error_info = parsed&.dig('errors', 0) || {}

          raise Exceptions.create_error_instance(
            type: error_info['error_type'],
            message: error_info['message'] || "HTTP #{env[:status]}",
            code: error_info['error_code'],
            request_id: parsed&.dig('request_id'),
            source: error_info['error_source']
          )
        when 429
          raise Exceptions::RateLimitError.new(
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

      def error_source(body)
        parsed = parse_body(body)
        parsed&.dig('errors', 0, 'error_source')
      end
    end
  end
end
