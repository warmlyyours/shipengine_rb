# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Ltl
      LTL_BASE = '/v-beta/ltl'

      def initialize(internal_client)
        @internal_client = internal_client
      end

      # List all LTL carriers connected to the account.
      # Carrier data includes embedded services, options, and package types.
      #
      # @param config [Hash?]
      # @return [Hash]
      def list_carriers(config: {})
        response = @internal_client.get("#{LTL_BASE}/carriers", {}, config)
        response.body
      end

      # Request an LTL freight quote from a specific carrier.
      #
      # @param carrier_id [String]
      # @param params [Hash] - quote request body (origin, destination, packages, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def get_quote(carrier_id, params, config: {})
        response = @internal_client.post("#{LTL_BASE}/quotes/#{carrier_id}", params, config)
        response.body
      end

      # List LTL quotes.
      #
      # @param params [Hash] - query params
      # @param config [Hash?]
      # @return [Hash]
      def list_quotes(params = {}, config: {})
        response = @internal_client.get("#{LTL_BASE}/quotes", params, config)
        response.body
      end

      # Get a specific LTL quote by ID.
      #
      # @param quote_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_quote_by_id(quote_id, config: {})
        response = @internal_client.get("#{LTL_BASE}/quotes/#{quote_id}", {}, config)
        response.body
      end

      # Schedule an LTL freight pickup.
      #
      # @param params [Hash] - pickup scheduling details
      # @param config [Hash?]
      # @return [Hash]
      def schedule_pickup(params, config: {})
        response = @internal_client.post("#{LTL_BASE}/pickups", params, config)
        response.body
      end

      # Get an LTL pickup by ID.
      #
      # @param pickup_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_pickup(pickup_id, config: {})
        response = @internal_client.get("#{LTL_BASE}/pickups/#{pickup_id}", {}, config)
        response.body
      end

      # Update an LTL pickup.
      #
      # @param pickup_id [String]
      # @param params [Hash] - updated pickup details
      # @param config [Hash?]
      # @return [Hash]
      def update_pickup(pickup_id, params, config: {})
        response = @internal_client.put("#{LTL_BASE}/pickups/#{pickup_id}", params, config)
        response.body
      end

      # Cancel an LTL pickup.
      #
      # @param pickup_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def cancel_pickup(pickup_id, config: {})
        response = @internal_client.delete("#{LTL_BASE}/pickups/#{pickup_id}", {}, config)
        response.body
      end

      # Track an LTL shipment.
      #
      # @param params [Hash] - tracking query params (carrier_code, tracking_number, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def track(params = {}, config: {})
        response = @internal_client.get("#{LTL_BASE}/tracking", params, config)
        response.body
      end
    end
  end
end
