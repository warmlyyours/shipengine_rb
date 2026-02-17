# frozen_string_literal: true

module ShipEngine
  module Domain
    class Manifests
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param params [Hash] - query params
      # @param config [Hash?]
      # @return [Hash]
      def list(params = {}, config: {})
        response = @internal_client.get('/v1/manifests', params, config)
        response.body
      end

      # @param params [Hash] - manifest creation details
      # @param config [Hash?]
      # @return [Hash]
      def create(params, config: {})
        response = @internal_client.post('/v1/manifests', params, config)
        response.body
      end

      # @param manifest_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(manifest_id, config: {})
        response = @internal_client.get("/v1/manifests/#{manifest_id}", {}, config)
        response.body
      end

      # @param request_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_request_by_id(request_id, config: {})
        response = @internal_client.get("/v1/manifests/requests/#{request_id}", {}, config)
        response.body
      end
    end
  end
end
