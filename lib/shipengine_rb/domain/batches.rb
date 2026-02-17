# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Batches domain for managing label batches.
    # Batches allow you to create multiple labels at once and process them together.
    class Batches
      include ShipEngineRb::Pagination

      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists all batches, optionally filtered by status and paginated.
      #
      # @param params [Hash] query params (page, page_size, status, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] paginated list of batches with batch_id, status, and shipment counts
      # @example
      #   batches = client.batches.list(page: 1, page_size: 25, status: "processing")
      def list(params = {}, config: {})
        @internal_client.get('/v1/batches', params, config)
      end

      def list_all(params = {}, config: {})
        paginate_all(:list, :batches, params, config:)
      end

      def list_each(params = {}, config: {}, &)
        paginate_each(:list, :batches, params, config:, &)
      end

      # @param params [Hash] - batch details (shipment_ids, rate_ids, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def create(params, config: {})
        @internal_client.post('/v1/batches', params, config)
      end

      # Retrieves a batch by its ShipEngine batch ID.
      #
      # @param batch_id [String] the unique identifier of the batch
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] batch details including status, shipments, and label URLs
      # @example
      #   batch = client.batches.get_by_id("batch_abc123")
      def get_by_id(batch_id, config: {})
        @internal_client.get("/v1/batches/#{batch_id}", {}, config)
      end

      # Deletes a batch. Only batches that have not been processed can be deleted.
      #
      # @param batch_id [String] the unique identifier of the batch to delete
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] empty response or confirmation of deletion
      # @example
      #   client.batches.delete("batch_abc123")
      def delete(batch_id, config: {})
        @internal_client.delete("/v1/batches/#{batch_id}", {}, config)
      end

      # Retrieves a batch by its external batch ID (your system's reference).
      #
      # @param external_batch_id [String] your external reference for the batch
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] batch details including status, shipments, and label URLs
      # @example
      #   batch = client.batches.get_by_external_id("order_batch_001")
      def get_by_external_id(external_batch_id, config: {})
        @internal_client.get("/v1/batches/external_batch_id/#{external_batch_id}", {}, config)
      end

      # Adds shipments to an existing batch.
      #
      # @param batch_id [String] the unique identifier of the batch
      # @param params [Hash] shipment_ids array of shipment IDs to add
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] updated batch with added shipments
      # @example
      #   batch = client.batches.add_shipments("batch_abc123", { shipment_ids: ["se_789"] })
      def add_shipments(batch_id, params, config: {})
        @internal_client.post("/v1/batches/#{batch_id}/add", params, config)
      end

      # Removes shipments from an existing batch.
      #
      # @param batch_id [String] the unique identifier of the batch
      # @param params [Hash] shipment_ids array of shipment IDs to remove
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] updated batch with shipments removed
      # @example
      #   batch = client.batches.remove_shipments("batch_abc123", { shipment_ids: ["se_789"] })
      def remove_shipments(batch_id, params, config: {})
        @internal_client.post("/v1/batches/#{batch_id}/remove", params, config)
      end

      # Processes a batch to generate labels for all shipments.
      #
      # @param batch_id [String] the unique identifier of the batch to process
      # @param params [Hash] processing options (e.g., label_layout, label_format)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] processing result with label URLs and status
      # @example
      #   result = client.batches.process("batch_abc123", { label_format: "pdf" })
      def process(batch_id, params = {}, config: {})
        @internal_client.post("/v1/batches/#{batch_id}/process/labels", params, config)
      end

      # Retrieves errors for a batch (e.g., validation or processing failures).
      #
      # @param batch_id [String] the unique identifier of the batch
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] list of errors with shipment_id, error code, and message
      # @example
      #   errors = client.batches.get_errors("batch_abc123")
      def get_errors(batch_id, config: {})
        @internal_client.get("/v1/batches/#{batch_id}/errors", {}, config)
      end
    end
  end
end
