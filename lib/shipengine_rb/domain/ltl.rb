# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # LTL Freight domain for Less-Than-Truckload shipping.
    # API base path: /v-beta/ltl/
    # Supports carriers, quotes, pickups, and tracking for LTL freight shipments.
    class Ltl
      LTL_BASE = '/v-beta/ltl'

      def initialize(internal_client)
        @internal_client = internal_client
      end

      # List all LTL carriers connected to the account.
      # Carrier data includes embedded services, options, and package types.
      #
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] list of LTL carriers with services, options, and package types
      # @example
      #   carriers = client.ltl.list_carriers
      def list_carriers(config: {})
        @internal_client.get("#{LTL_BASE}/carriers", {}, config)
      end

      # Request an LTL freight quote from a specific carrier.
      #
      # @param carrier_id [String] the LTL carrier ID
      # @param params [Hash] quote request body (origin, destination, packages, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] quote details including rate, transit time, and service info
      # @example
      #   quote = client.ltl.get_quote("se_123", { origin: {...}, destination: {...}, packages: [...] })
      def get_quote(carrier_id, params, config: {})
        @internal_client.post("#{LTL_BASE}/quotes/#{carrier_id}", params, config)
      end

      # List LTL quotes.
      #
      # @param params [Hash] query params for filtering and pagination
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] paginated list of LTL quotes
      # @example
      #   quotes = client.ltl.list_quotes(page: 1, page_size: 25)
      def list_quotes(params = {}, config: {})
        @internal_client.get("#{LTL_BASE}/quotes", params, config)
      end

      # Get a specific LTL quote by ID.
      #
      # @param quote_id [String] the unique identifier of the LTL quote
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] quote details including rate, carrier, and shipment info
      # @example
      #   quote = client.ltl.get_quote_by_id("se_quote_123")
      def get_quote_by_id(quote_id, config: {})
        @internal_client.get("#{LTL_BASE}/quotes/#{quote_id}", {}, config)
      end

      # Schedule an LTL freight pickup.
      #
      # @param params [Hash] pickup scheduling details (carrier_id, pickup_window, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] pickup confirmation with pickup_id and scheduled time
      # @example
      #   pickup = client.ltl.schedule_pickup({ carrier_id: "se_123", pickup_window: {...} })
      def schedule_pickup(params, config: {})
        @internal_client.post("#{LTL_BASE}/pickups", params, config)
      end

      # Get an LTL pickup by ID.
      #
      # @param pickup_id [String] the unique identifier of the pickup
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] pickup details including status, window, and carrier info
      # @example
      #   pickup = client.ltl.get_pickup("se_pickup_123")
      def get_pickup(pickup_id, config: {})
        @internal_client.get("#{LTL_BASE}/pickups/#{pickup_id}", {}, config)
      end

      # Update an LTL pickup.
      #
      # @param pickup_id [String] the unique identifier of the pickup to update
      # @param params [Hash] updated pickup details (pickup_window, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] the updated pickup details
      # @example
      #   pickup = client.ltl.update_pickup("se_pickup_123", { pickup_window: {...} })
      def update_pickup(pickup_id, params, config: {})
        @internal_client.put("#{LTL_BASE}/pickups/#{pickup_id}", params, config)
      end

      # Cancel an LTL pickup.
      #
      # @param pickup_id [String] the unique identifier of the pickup to cancel
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] empty response or confirmation of cancellation
      # @example
      #   client.ltl.cancel_pickup("se_pickup_123")
      def cancel_pickup(pickup_id, config: {})
        @internal_client.delete("#{LTL_BASE}/pickups/#{pickup_id}", {}, config)
      end

      # Track an LTL shipment.
      #
      # @param params [Hash] tracking query params (carrier_code, tracking_number, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] tracking info with status, events, and estimated delivery
      # @example
      #   tracking = client.ltl.track({ carrier_code: "se_123", tracking_number: "1Z999..." })
      def track(params = {}, config: {})
        @internal_client.get("#{LTL_BASE}/tracking", params, config)
      end
    end
  end
end
