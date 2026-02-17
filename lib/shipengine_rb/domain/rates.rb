# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Shipping rate retrieval. Get rates for shipments, estimate rates with
    # partial details, and perform bulk rate lookups.
    #
    # @example Basic usage
    #   client = ShipEngineRb::Client.new("YOUR_API_KEY")
    #   rates = client.rates.get_with_shipment_details(shipment_details)
    #   estimate = client.rates.estimate({ ship_to: { postal_code: "78701", country_code: "US" } })
    #   rate = client.rates.get_by_id("se-123")
    #
    # @see https://shipengine.github.io/shipengine-openapi/
    class Rates
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Gets shipping rates for a shipment with full details (carrier, service, addresses, packages).
      #
      # @param shipment_details [Hash] Shipment details including carrier_ids, service_codes, ship_to, ship_from, packages.
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Response with rates array (rate_id, carrier, service, amount, delivery_days, etc.).
      # @example
      #   rates = client.rates.get_with_shipment_details({
      #     carrier_ids: ["se-123"],
      #     service_codes: ["usps_priority_mail"],
      #     ship_to: { postal_code: "78701", country_code: "US" },
      #     ship_from: { postal_code: "10001", country_code: "US" },
      #     packages: [{ weight: { value: 1, unit: "ounce" } }]
      #   })
      # @see https://shipengine.github.io/shipengine-openapi/
      def get_with_shipment_details(shipment_details, config: {})
        response = @internal_client.post('/v1/rates', shipment_details, config)
        response.body
      end

      # Estimates shipping rates with partial shipment details (e.g. destination only).
      #
      # @param shipment_details [Hash] Partial shipment details (e.g. ship_to with postal_code and country_code).
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Response with rate estimates (carrier, service, amount, delivery_days).
      # @example
      #   estimate = client.rates.estimate({
      #     ship_to: { postal_code: "78701", country_code: "US" }
      #   })
      # @see https://shipengine.github.io/shipengine-openapi/
      def estimate(shipment_details, config: {})
        response = @internal_client.post('/v1/rates/estimate', shipment_details, config)
        response.body
      end

      # Retrieves a single rate by ID (from a previous rate lookup).
      #
      # @param rate_id [String] The rate ID (e.g. "se-123").
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Rate details including carrier, service, amount, delivery_days, and shipment info.
      # @example
      #   rate = client.rates.get_by_id("se-123")
      # @see https://shipengine.github.io/shipengine-openapi/
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
