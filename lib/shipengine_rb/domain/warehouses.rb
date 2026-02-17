# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Warehouses
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def list(config: {})
        response = @internal_client.get('/v1/warehouses', {}, config)
        response.body
      end

      # @param params [Hash] - warehouse details
      # @param config [Hash?]
      # @return [Hash]
      def create(params, config: {})
        response = @internal_client.post('/v1/warehouses', params, config)
        response.body
      end

      # @param warehouse_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(warehouse_id, config: {})
        response = @internal_client.get("/v1/warehouses/#{warehouse_id}", {}, config)
        response.body
      end

      # @param warehouse_id [String]
      # @param params [Hash] - updated warehouse details
      # @param config [Hash?]
      # @return [Hash]
      def update(warehouse_id, params, config: {})
        response = @internal_client.put("/v1/warehouses/#{warehouse_id}", params, config)
        response.body
      end

      # @param warehouse_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def delete(warehouse_id, config: {})
        response = @internal_client.delete("/v1/warehouses/#{warehouse_id}", {}, config)
        response.body
      end

      # @param warehouse_id [String]
      # @param params [Hash] - warehouse settings
      # @param config [Hash?]
      # @return [Hash]
      def update_settings(warehouse_id, params, config: {})
        response = @internal_client.put("/v1/warehouses/#{warehouse_id}/settings", params, config)
        response.body
      end
    end
  end
end
