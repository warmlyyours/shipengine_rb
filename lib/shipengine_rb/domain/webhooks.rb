# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Domain class for managing webhooks. Provides methods to list, create,
    # retrieve, update, and delete webhook subscriptions for event notifications.
    class Webhooks
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists all webhooks in the account.
      #
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the list of webhooks.
      #
      # @example
      #   client.webhooks.list
      def list(config: {})
        @internal_client.get('/v1/environment/webhooks', {}, config)
      end

      # Creates a new webhook subscription.
      #
      # @param params [Hash] Webhook details (url, event, etc.).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the created webhook.
      #
      # @example
      #   client.webhooks.create(url: "https://example.com/webhook", event: "track")
      def create(params, config: {})
        @internal_client.post('/v1/environment/webhooks', params, config)
      end

      # Retrieves a webhook by its ID.
      #
      # @param webhook_id [String] The unique identifier of the webhook.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the webhook details.
      #
      # @example
      #   client.webhooks.get_by_id("se-webhook-123")
      def get_by_id(webhook_id, config: {})
        @internal_client.get("/v1/environment/webhooks/#{webhook_id}", {}, config)
      end

      # Updates an existing webhook.
      #
      # @param webhook_id [String] The unique identifier of the webhook to update.
      # @param params [Hash] Updated webhook details.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the updated webhook.
      #
      # @example
      #   client.webhooks.update("se-webhook-123", url: "https://example.com/new-webhook")
      def update(webhook_id, params, config: {})
        @internal_client.put("/v1/environment/webhooks/#{webhook_id}", params, config)
      end

      # Deletes a webhook subscription.
      #
      # @param webhook_id [String] The unique identifier of the webhook to delete.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the deletion.
      #
      # @example
      #   client.webhooks.delete("se-webhook-123")
      def delete(webhook_id, config: {})
        @internal_client.delete("/v1/environment/webhooks/#{webhook_id}", {}, config)
      end
    end
  end
end
