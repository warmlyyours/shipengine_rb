# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Domain class for managing package types. Provides methods to list, create,
    # retrieve, update, and delete custom package types.
    class PackageTypes
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists all package types (both carrier-defined and custom).
      #
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the list of package types.
      #
      # @example
      #   client.package_types.list
      def list(config: {})
        @internal_client.get('/v1/packages', {}, config)
      end

      # Creates a new custom package type.
      #
      # @param params [Hash] Package type details (name, dimensions, weight, etc.).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the created package type.
      #
      # @example
      #   client.package_types.create(name: "My Box", length: 10, width: 8, height: 6)
      def create(params, config: {})
        @internal_client.post('/v1/packages', params, config)
      end

      # Retrieves a package type by its ID.
      #
      # @param package_id [String] The unique identifier of the package type.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the package type details.
      #
      # @example
      #   client.package_types.get_by_id("se-pkg-123")
      def get_by_id(package_id, config: {})
        @internal_client.get("/v1/packages/#{package_id}", {}, config)
      end

      # Updates an existing custom package type.
      #
      # @param package_id [String] The unique identifier of the package type to update.
      # @param params [Hash] Updated package type details (name, dimensions, etc.).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the updated package type.
      #
      # @example
      #   client.package_types.update("se-pkg-123", name: "Updated Box", length: 12)
      def update(package_id, params, config: {})
        @internal_client.put("/v1/packages/#{package_id}", params, config)
      end

      # Deletes a custom package type.
      #
      # @param package_id [String] The unique identifier of the package type to delete.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the deletion.
      #
      # @example
      #   client.package_types.delete("se-pkg-123")
      def delete(package_id, config: {})
        @internal_client.delete("/v1/packages/#{package_id}", {}, config)
      end
    end
  end
end
