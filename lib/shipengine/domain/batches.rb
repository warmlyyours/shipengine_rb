# frozen_string_literal: true

module ShipEngine
  module Domain
    class Batches
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param params [Hash] - query params (page, page_size, status, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def list(params = {}, config: {})
        response = @internal_client.get('/v1/batches', params, config)
        response.body
      end

      # @param params [Hash] - batch details (shipment_ids, rate_ids, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def create(params, config: {})
        response = @internal_client.post('/v1/batches', params, config)
        response.body
      end

      # @param batch_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(batch_id, config: {})
        response = @internal_client.get("/v1/batches/#{batch_id}", {}, config)
        response.body
      end

      # @param batch_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def delete(batch_id, config: {})
        response = @internal_client.delete("/v1/batches/#{batch_id}", {}, config)
        response.body
      end

      # @param external_batch_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_external_id(external_batch_id, config: {})
        response = @internal_client.get("/v1/batches/external_batch_id/#{external_batch_id}", {}, config)
        response.body
      end

      # @param batch_id [String]
      # @param params [Hash] - shipment_ids to add
      # @param config [Hash?]
      # @return [Hash]
      def add_shipments(batch_id, params, config: {})
        response = @internal_client.post("/v1/batches/#{batch_id}/add", params, config)
        response.body
      end

      # @param batch_id [String]
      # @param params [Hash] - shipment_ids to remove
      # @param config [Hash?]
      # @return [Hash]
      def remove_shipments(batch_id, params, config: {})
        response = @internal_client.post("/v1/batches/#{batch_id}/remove", params, config)
        response.body
      end

      # @param batch_id [String]
      # @param params [Hash] - processing options
      # @param config [Hash?]
      # @return [Hash]
      def process(batch_id, params = {}, config: {})
        response = @internal_client.post("/v1/batches/#{batch_id}/process/labels", params, config)
        response.body
      end

      # @param batch_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_errors(batch_id, config: {})
        response = @internal_client.get("/v1/batches/#{batch_id}/errors", {}, config)
        response.body
      end
    end
  end
end
