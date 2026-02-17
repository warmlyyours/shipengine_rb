# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # CarrierAccounts domain for connecting and managing carrier connections.
    # Handles OAuth and credential-based connections to carriers like FedEx, UPS, Stamps.com.
    class CarrierAccounts
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Connects a carrier account to your ShipEngine account.
      #
      # @param carrier_name [String] carrier identifier (e.g., "stamps_com", "fedex", "ups")
      # @param params [Hash] carrier account connection details (credentials, OAuth tokens, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] connection result with carrier_id and connection status
      # @example
      #   result = client.carrier_accounts.connect("fedex", { credentials: { ... } })
      def connect(carrier_name, params, config: {})
        response = @internal_client.post("/v1/connections/carriers/#{carrier_name}", params, config)
        response.body
      end

      # Disconnects a carrier account from your ShipEngine account.
      #
      # @param carrier_name [String] carrier identifier (e.g., "fedex", "ups")
      # @param carrier_id [String] the ShipEngine carrier connection ID to disconnect
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] empty response or confirmation of disconnection
      # @example
      #   client.carrier_accounts.disconnect("fedex", "se_123")
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

      # Updates settings for a connected carrier account.
      #
      # @param carrier_name [String] carrier identifier (e.g., "fedex", "ups")
      # @param carrier_id [String] the ShipEngine carrier connection ID
      # @param params [Hash] updated settings (nickname, default_service_type, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] the updated carrier settings
      # @example
      #   settings = client.carrier_accounts.update_settings("fedex", "se_123", { nickname: "Main FedEx" })
      def update_settings(carrier_name, carrier_id, params, config: {})
        response = @internal_client.put(
          "/v1/connections/carriers/#{carrier_name}/#{carrier_id}/settings", params, config
        )
        response.body
      end
    end
  end
end
