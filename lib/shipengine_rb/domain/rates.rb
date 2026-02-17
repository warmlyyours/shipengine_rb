# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Rates
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param shipment_details [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def get_with_shipment_details(shipment_details, config: {})
        response = @internal_client.post('/v1/rates', shipment_details, config)
        response.body
      end

      # @param shipment_details [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def estimate(shipment_details, config: {})
        response = @internal_client.post('/v1/rates/estimate', shipment_details, config)
        response.body
      end

      # @param rate_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(rate_id, config: {})
        response = @internal_client.get("/v1/rates/#{rate_id}", {}, config)
        response.body
      end

      # @param params [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def bulk(params, config: {})
        response = @internal_client.post('/v1/rates/bulk', params, config)
        response.body
      end
    end
  end
end
