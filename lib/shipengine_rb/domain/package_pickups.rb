# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class PackagePickups
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param params [Hash] - query params
      # @param config [Hash?]
      # @return [Hash]
      def list(params = {}, config: {})
        response = @internal_client.get('/v1/pickups', params, config)
        response.body
      end

      # @param params [Hash] - pickup scheduling details
      # @param config [Hash?]
      # @return [Hash]
      def schedule(params, config: {})
        response = @internal_client.post('/v1/pickups', params, config)
        response.body
      end

      # @param pickup_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(pickup_id, config: {})
        response = @internal_client.get("/v1/pickups/#{pickup_id}", {}, config)
        response.body
      end

      # @param pickup_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def delete(pickup_id, config: {})
        response = @internal_client.delete("/v1/pickups/#{pickup_id}", {}, config)
        response.body
      end
    end
  end
end
