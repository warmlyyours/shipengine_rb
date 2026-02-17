# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Webhooks
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def list(config: {})
        response = @internal_client.get('/v1/environment/webhooks', {}, config)
        response.body
      end

      # @param params [Hash] - webhook details (url, event, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def create(params, config: {})
        response = @internal_client.post('/v1/environment/webhooks', params, config)
        response.body
      end

      # @param webhook_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(webhook_id, config: {})
        response = @internal_client.get("/v1/environment/webhooks/#{webhook_id}", {}, config)
        response.body
      end

      # @param webhook_id [String]
      # @param params [Hash] - updated webhook details
      # @param config [Hash?]
      # @return [Hash]
      def update(webhook_id, params, config: {})
        response = @internal_client.put("/v1/environment/webhooks/#{webhook_id}", params, config)
        response.body
      end

      # @param webhook_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def delete(webhook_id, config: {})
        response = @internal_client.delete("/v1/environment/webhooks/#{webhook_id}", {}, config)
        response.body
      end
    end
  end
end
