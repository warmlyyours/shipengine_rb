# frozen_string_literal: true

module ShipEngine
  module Domain
    class CarrierAccounts
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param carrier_name [String] - e.g. "stamps_com", "fedex", "ups"
      # @param params [Hash] - carrier account connection details
      # @param config [Hash?]
      # @return [Hash]
      def connect(carrier_name, params, config: {})
        response = @internal_client.post("/v1/connections/carriers/#{carrier_name}", params, config)
        response.body
      end

      # @param carrier_name [String]
      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def disconnect(carrier_name, carrier_id, config: {})
        response = @internal_client.delete("/v1/connections/carriers/#{carrier_name}/#{carrier_id}", {}, config)
        response.body
      end

      # @param carrier_name [String]
      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_settings(carrier_name, carrier_id, config: {})
        response = @internal_client.get("/v1/connections/carriers/#{carrier_name}/#{carrier_id}/settings", {}, config)
        response.body
      end

      # @param carrier_name [String]
      # @param carrier_id [String]
      # @param params [Hash] - updated settings
      # @param config [Hash?]
      # @return [Hash]
      def update_settings(carrier_name, carrier_id, params, config: {})
        response = @internal_client.put(
          "/v1/connections/carriers/#{carrier_name}/#{carrier_id}/settings", params, config
        )
        response.body
      end
    end
  end
end
