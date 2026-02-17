# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Carriers
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def list(config: {})
        response = @internal_client.get('/v1/carriers', {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
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
