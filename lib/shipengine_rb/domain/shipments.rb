# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Shipments
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param params [Hash] - query params (page, page_size, shipment_status, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def list(params = {}, config: {})
        response = @internal_client.get('/v1/shipments', params, config)
        response.body
      end

      # @param params [Hash] - shipment details
      # @param config [Hash?]
      # @return [Hash]
      def create(params, config: {})
        response = @internal_client.post('/v1/shipments', params, config)
        response.body
      end

      # @param shipment_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(shipment_id, config: {})
        response = @internal_client.get("/v1/shipments/#{shipment_id}", {}, config)
        response.body
      end

      # @param shipment_id [String]
      # @param params [Hash] - updated shipment details
      # @param config [Hash?]
      # @return [Hash]
      def update(shipment_id, params, config: {})
        response = @internal_client.put("/v1/shipments/#{shipment_id}", params, config)
        response.body
      end

      # @param shipment_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def cancel(shipment_id, config: {})
        response = @internal_client.put("/v1/shipments/#{shipment_id}/cancel", {}, config)
        response.body
      end

      # @param shipment_id [String]
      # @param tag_name [String]
      # @param config [Hash?]
      # @return [Hash]
      def add_tag(shipment_id, tag_name, config: {})
        response = @internal_client.post("/v1/shipments/#{shipment_id}/tags/#{tag_name}", {}, config)
        response.body
      end

      # @param shipment_id [String]
      # @param tag_name [String]
      # @param config [Hash?]
      # @return [Hash]
      def remove_tag(shipment_id, tag_name, config: {})
        response = @internal_client.delete("/v1/shipments/#{shipment_id}/tags/#{tag_name}", {}, config)
        response.body
      end

      # @param external_shipment_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_external_id(external_shipment_id, config: {})
        response = @internal_client.get("/v1/shipments/external_shipment_id/#{external_shipment_id}", {}, config)
        response.body
      end

      # @param params [Hash] - text and address to parse
      # @param config [Hash?]
      # @return [Hash]
      def parse(params, config: {})
        response = @internal_client.put('/v1/shipments/recognize', params, config)
        response.body
      end

      # @param shipment_id [String]
      # @param params [Hash] - query params (e.g. created_at_start)
      # @param config [Hash?]
      # @return [Hash]
      def get_rates(shipment_id, params = {}, config: {})
        response = @internal_client.get("/v1/shipments/#{shipment_id}/rates", params, config)
        response.body
      end

      # @param shipment_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def list_tags(shipment_id, config: {})
        response = @internal_client.get("/v1/shipments/#{shipment_id}/tags", {}, config)
        response.body
      end

      # @param params [Hash] - bulk tag update body
      # @param config [Hash?]
      # @return [Hash]
      def update_tags(params, config: {})
        response = @internal_client.put('/v1/shipments/tags', params, config)
        response.body
      end
    end
  end
end
