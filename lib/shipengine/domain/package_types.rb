# frozen_string_literal: true

module ShipEngine
  module Domain
    class PackageTypes
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def list(config: {})
        response = @internal_client.get('/v1/packages', {}, config)
        response.body
      end

      # @param params [Hash] - package type details
      # @param config [Hash?]
      # @return [Hash]
      def create(params, config: {})
        response = @internal_client.post('/v1/packages', params, config)
        response.body
      end

      # @param package_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(package_id, config: {})
        response = @internal_client.get("/v1/packages/#{package_id}", {}, config)
        response.body
      end

      # @param package_id [String]
      # @param params [Hash] - updated package type details
      # @param config [Hash?]
      # @return [Hash]
      def update(package_id, params, config: {})
        response = @internal_client.put("/v1/packages/#{package_id}", params, config)
        response.body
      end

      # @param package_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def delete(package_id, config: {})
        response = @internal_client.delete("/v1/packages/#{package_id}", {}, config)
        response.body
      end
    end
  end
end
