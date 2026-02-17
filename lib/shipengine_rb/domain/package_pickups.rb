# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Domain class for managing package pickups. Provides methods to list, schedule,
    # retrieve, and delete carrier pickups.
    class PackagePickups
      include ShipEngineRb::Pagination

      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists package pickups with optional filtering via query parameters.
      #
      # @param params [Hash] Query parameters for filtering pickups (e.g., page, page_size, status).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing pickup list and pagination metadata.
      #
      # @example
      #   client.package_pickups.list(page: 1, page_size: 25)
      def list(params = {}, config: {})
        @internal_client.get('/v1/pickups', params, config)
      end

      def list_all(params = {}, config: {})
        paginate_all(:list, :pickups, params, config:)
      end

      def list_each(params = {}, config: {}, &)
        paginate_each(:list, :pickups, params, config:, &)
      end

      # Schedules a carrier pickup for packages.
      #
      # @param params [Hash] Pickup scheduling details (carrier_id, label_ids, etc.).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the scheduled pickup details.
      #
      # @example
      #   client.package_pickups.schedule(carrier_id: "se-123", label_ids: ["se-label-456"])
      def schedule(params, config: {})
        @internal_client.post('/v1/pickups', params, config)
      end

      # Retrieves a single pickup by its ID.
      #
      # @param pickup_id [String] The unique identifier of the pickup.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the pickup details.
      #
      # @example
      #   client.package_pickups.get_by_id("se-pickup-123")
      def get_by_id(pickup_id, config: {})
        @internal_client.get("/v1/pickups/#{pickup_id}", {}, config)
      end

      # Cancels or deletes a scheduled pickup.
      #
      # @param pickup_id [String] The unique identifier of the pickup to delete.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the deletion.
      #
      # @example
      #   client.package_pickups.delete("se-pickup-123")
      def delete(pickup_id, config: {})
        @internal_client.delete("/v1/pickups/#{pickup_id}", {}, config)
      end
    end
  end
end
