# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Domain class for carrier service points (e.g., pickup/dropoff locations).
    # Provides methods to list and retrieve service point details.
    class ServicePoints
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists service points matching the given criteria (carrier, location, etc.).
      #
      # @param params [Hash] Query params (carrier_code, country_code, postal_code, etc.).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the list of service points.
      #
      # @example
      #   client.service_points.list(carrier_code: "ups", country_code: "US", postal_code: "78756")
      def list(params = {}, config: {})
        @internal_client.post('/v1/service_points/list', params, config)
      end

      # Retrieves a single service point by carrier, country, and service point ID.
      #
      # @param carrier_code [String] The carrier code (e.g., "ups", "fedex").
      # @param country_code [String] The ISO 3166-1 alpha-2 country code.
      # @param service_point_id [String] The unique identifier of the service point.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the service point details.
      #
      # @example
      #   client.service_points.get_by_id("ups", "US", "12345")
      def get_by_id(carrier_code, country_code, service_point_id, config: {})
        @internal_client.get(
          "/v1/service_points/#{carrier_code}/#{country_code}/#{service_point_id}", {}, config
        )
      end
    end
  end
end
