# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Package tracking. Track packages by label ID or carrier/tracking number,
    # and start or stop tracking webhooks for a package.
    #
    # @example Basic usage
    #   client = ShipEngineRb::Client.new("YOUR_API_KEY")
    #   info = client.tracking.track_by_label_id("se-123")
    #   info = client.tracking.track("ups", "1Z999AA10123456784")
    #   client.tracking.start("ups", "1Z999AA10123456784")
    #
    # @see https://shipengine.github.io/shipengine-openapi/
    class Tracking
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Gets tracking information for a package by its ShipEngine label ID.
      #
      # @param label_id [String] The ShipEngine label ID (e.g. "se-123").
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Tracking info with carrier, tracking_number, status, events, and estimated_delivery.
      # @example
      #   info = client.tracking.track_by_label_id("se-123")
      # @see https://shipengine.github.io/shipengine-openapi/
      def track_by_label_id(label_id, config: {})
        @internal_client.get("/v1/labels/#{label_id}/track", {}, config)
      end

      # @param carrier_code [String]
      # @param tracking_number [String]
      # @param config [Hash?]
      # @return [Hash]
      def track(carrier_code, tracking_number, config: {})
        @internal_client.get('/v1/tracking', { carrier_code:, tracking_number: }, config)
      end

      # Starts real-time tracking updates (webhooks) for a package.
      #
      # ShipEngine's POST /v1/tracking/start endpoint reads carrier_code
      # and tracking_number from the query string, NOT the request body
      # (verified against the live API 2026-05-28 — sending in the body
      # 100%-returns `BusinessRulesError: Invalid tracking_number.`
      # regardless of input validity). Pass them via the InternalClient
      # `:query` config so they're appended to the URL.
      #
      # @param carrier_code [String] Carrier code (e.g. "ups", "fedex", "usps").
      # @param tracking_number [String] The carrier's tracking number.
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Confirmation of tracking subscription.
      # @example
      #   client.tracking.start("ups", "1Z999AA10123456784")
      # @see https://shipengine.github.io/shipengine-openapi/
      def start(carrier_code, tracking_number, config: {})
        merged_config = config.merge(query: { carrier_code:, tracking_number: })
        @internal_client.post('/v1/tracking/start', {}, merged_config)
      end

      # Stops real-time tracking updates (webhooks) for a package.
      #
      # Same query-string requirement as {#start} (sibling endpoint with
      # identical request shape on the SE side).
      #
      # @param carrier_code [String] Carrier code (e.g. "ups", "fedex", "usps").
      # @param tracking_number [String] The carrier's tracking number.
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Confirmation that tracking subscription was stopped.
      # @example
      #   client.tracking.stop("ups", "1Z999AA10123456784")
      # @see https://shipengine.github.io/shipengine-openapi/
      def stop(carrier_code, tracking_number, config: {})
        merged_config = config.merge(query: { carrier_code:, tracking_number: })
        @internal_client.post('/v1/tracking/stop', {}, merged_config)
      end
    end
  end
end
