# frozen_string_literal: true

require 'faraday'
require 'json'

module ShipEngineRb
  module Middleware
    class RaiseHttpException < Faraday::Middleware
      def on_complete(env)
        status = env[:status].to_i
        case status
        when 400, 401, 403, 404, 500, 502, 503, 504
          parsed = parse_body(env[:body])
          error = extract_first_error(parsed)

          err = Exceptions.create_error_instance(
            type: error[:error_type],
            message: error[:message] || "HTTP #{status}",
            code: error[:error_code],
            request_id: parsed.is_a?(Hash) ? (parsed[:request_id] || parsed['request_id']) : nil,
            source: error[:error_source]
          )
          attach_http_context(err, env, parsed)
          raise err
        when 429
          parsed = parse_body(env[:body])
          error = extract_first_error(parsed)

          err = Exceptions::RateLimitError.new(
            retries: env.request_headers['Retries'].to_i,
            source: error[:error_source],
            request_id: parsed.is_a?(Hash) ? (parsed[:request_id] || parsed['request_id']) : nil
          )
          attach_http_context(err, env, parsed)
          raise err
        end
      end

      private

      def parse_body(body)
        return nil if body.nil? || (body.is_a?(String) && body.empty?)
        return body unless body.is_a?(String)

        JSON.parse(body, symbolize_names: true)
      rescue JSON::ParserError
        nil
      end

      def extract_first_error(parsed)
        return {} unless parsed.is_a?(Hash)

        errors = parsed[:errors] || parsed['errors'] || []
        err = errors.first || {}
        {
          error_type: err[:error_type] || err['error_type'],
          message: err[:message] || err['message'],
          error_code: err[:error_code] || err['error_code'],
          error_source: err[:error_source] || err['error_source']
        }
      end

      # Stamp the raised exception with the parsed body, HTTP status, and
      # request URL so consumers (loggers, error reporters) can dump the
      # full HTTP context instead of just the structured fields.
      def attach_http_context(err, env, parsed)
        err.response_body = parsed
        err.response_status = env[:status].to_i
        err.request_url = env[:url].to_s if env[:url]
      end
    end
  end
end
