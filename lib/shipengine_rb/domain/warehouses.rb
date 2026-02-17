# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Domain class for managing warehouses. Provides methods to list, create,
    # retrieve, update, delete warehouses, and update warehouse settings.
    class Warehouses
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists all warehouses in the account.
      #
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the list of warehouses.
      #
      # @example
      #   client.warehouses.list
      def list(config: {})
        @internal_client.get('/v1/warehouses', {}, config)
      end

      # Creates a new warehouse.
      #
      # @param params [Hash] Warehouse details (name, address, etc.).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the created warehouse.
      #
      # @example
      #   client.warehouses.create(name: "Main Warehouse", address: {...})
      def create(params, config: {})
        @internal_client.post('/v1/warehouses', params, config)
      end

      # Retrieves a warehouse by its ID.
      #
      # @param warehouse_id [String] The unique identifier of the warehouse.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the warehouse details.
      #
      # @example
      #   client.warehouses.get_by_id("se-warehouse-123")
      def get_by_id(warehouse_id, config: {})
        @internal_client.get("/v1/warehouses/#{warehouse_id}", {}, config)
      end

      # Updates an existing warehouse.
      #
      # @param warehouse_id [String] The unique identifier of the warehouse to update.
      # @param params [Hash] Updated warehouse details.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the updated warehouse.
      #
      # @example
      #   client.warehouses.update("se-warehouse-123", name: "Updated Warehouse")
      def update(warehouse_id, params, config: {})
        @internal_client.put("/v1/warehouses/#{warehouse_id}", params, config)
      end

      # Deletes a warehouse.
      #
      # @param warehouse_id [String] The unique identifier of the warehouse to delete.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the deletion.
      #
      # @example
      #   client.warehouses.delete("se-warehouse-123")
      def delete(warehouse_id, config: {})
        @internal_client.delete("/v1/warehouses/#{warehouse_id}", {}, config)
      end

      # Updates settings for a warehouse.
      #
      # @param warehouse_id [String] The unique identifier of the warehouse.
      # @param params [Hash] Warehouse settings to update.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the updated warehouse settings.
      #
      # @example
      #   client.warehouses.update_settings("se-warehouse-123", default_carrier: "ups")
      def update_settings(warehouse_id, params, config: {})
        @internal_client.put("/v1/warehouses/#{warehouse_id}/settings", params, config)
      end
    end
  end
end
