# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Manifests domain for creating and managing carrier manifests.
    # Manifests are used to close out a day's shipments with carriers.
    class Manifests
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists manifests, optionally filtered and paginated.
      #
      # @param params [Hash] query params (page, page_size, carrier_id, created_at_start, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] paginated list of manifests with manifest_id, carrier_id, and status
      # @example
      #   manifests = client.manifests.list(page: 1, page_size: 25)
      def list(params = {}, config: {})
        response = @internal_client.get('/v1/manifests', params, config)
        response.body
      end

      # Creates a new manifest for a carrier.
      #
      # @param params [Hash] manifest creation details (carrier_id, ship_date, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] the created manifest with manifest_id and form data
      # @example
      #   manifest = client.manifests.create({ carrier_id: "se_123", ship_date: "2024-01-15" })
      def create(params, config: {})
        response = @internal_client.post('/v1/manifests', params, config)
        response.body
      end

      # Retrieves a manifest by its ShipEngine manifest ID.
      #
      # @param manifest_id [String] the unique identifier of the manifest
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] manifest details including form_data, carrier_id, and label_ids
      # @example
      #   manifest = client.manifests.get_by_id("se_manifest_123")
      def get_by_id(manifest_id, config: {})
        response = @internal_client.get("/v1/manifests/#{manifest_id}", {}, config)
        response.body
      end

      # Retrieves a manifest request by its request ID (for async manifest creation).
      #
      # @param request_id [String] the unique identifier of the manifest request
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] manifest request status and resulting manifest_id when complete
      # @example
      #   request = client.manifests.get_request_by_id("se_request_123")
      def get_request_by_id(request_id, config: {})
        response = @internal_client.get("/v1/manifests/requests/#{request_id}", {}, config)
        response.body
      end
    end
  end
end
