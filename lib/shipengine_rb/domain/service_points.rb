# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class ServicePoints
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param params [Hash] - query params (carrier_code, country_code, postal_code, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def list(params = {}, config: {})
        response = @internal_client.post('/v1/service_points/list', params, config)
        response.body
      end

      # @param carrier_code [String]
      # @param country_code [String]
      # @param service_point_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(carrier_code, country_code, service_point_id, config: {})
        response = @internal_client.get(
          "/v1/service_points/#{carrier_code}/#{country_code}/#{service_point_id}", {}, config
        )
        response.body
      end
    end
  end
end
