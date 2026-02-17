# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Carrier management. List connected carriers, get carrier details, disconnect
    # carriers, add funds, and list services, packages, and options per carrier.
    #
    # @example Basic usage
    #   client = ShipEngineRb::Client.new("YOUR_API_KEY")
    #   carriers = client.carriers.list
    #   carrier = client.carriers.get_by_id("se-123")
    #   services = client.carriers.list_services("se-123")
    #
    # @see https://shipengine.github.io/shipengine-openapi/
    class Carriers
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists all carriers connected to the account.
      #
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Response with carriers array and pagination info.
      # @example
      #   result = client.carriers.list
      # @see https://shipengine.github.io/shipengine-openapi/
      def list(config: {})
        response = @internal_client.get('/v1/carriers', {}, config)
        response.body
      end

      # Retrieves a single carrier by ID.
      #
      # @param carrier_id [String] The carrier ID (e.g. "se-123").
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Carrier details including name, type, services, and account status.
      # @example
      #   carrier = client.carriers.get_by_id("se-123")
      # @see https://shipengine.github.io/shipengine-openapi/
      def get_by_id(carrier_id, config: {})
        response = @internal_client.get("/v1/carriers/#{carrier_id}", {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def disconnect(carrier_id, config: {})
        response = @internal_client.delete("/v1/carriers/#{carrier_id}", {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param amount [Hash] - { currency:, amount: }
      # @param config [Hash?]
      # @return [Hash]
      def add_funds(carrier_id, amount, config: {})
        response = @internal_client.put("/v1/carriers/#{carrier_id}/add_funds", amount, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def list_services(carrier_id, config: {})
        response = @internal_client.get("/v1/carriers/#{carrier_id}/services", {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def list_packages(carrier_id, config: {})
        response = @internal_client.get("/v1/carriers/#{carrier_id}/packages", {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def list_options(carrier_id, config: {})
        response = @internal_client.get("/v1/carriers/#{carrier_id}/options", {}, config)
        response.body
      end
    end
  end
end
