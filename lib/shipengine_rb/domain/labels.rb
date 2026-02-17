# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Labels
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param rate_id [String]
      # @param params [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def create_from_rate(rate_id, params = {}, config: {})
        response = @internal_client.post("/v1/labels/rates/#{rate_id}", params, config)
        response.body
      end

      # @param params [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def create_from_shipment_details(params, config: {})
        response = @internal_client.post('/v1/labels', params, config)
        response.body
      end

      # @param label_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def void(label_id, config: {})
        response = @internal_client.put("/v1/labels/#{label_id}/void", {}, config)
        response.body
      end

      # @param params [Hash] - query params (e.g. page, page_size, label_status, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def list(params = {}, config: {})
        response = @internal_client.get('/v1/labels', params, config)
        response.body
      end

      # @param label_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(label_id, config: {})
        response = @internal_client.get("/v1/labels/#{label_id}", {}, config)
        response.body
      end

      # @param external_shipment_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_external_shipment_id(external_shipment_id, config: {})
        response = @internal_client.get("/v1/labels/external_shipment_id/#{external_shipment_id}", {}, config)
        response.body
      end

      # @param label_id [String]
      # @param params [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def create_return_label(label_id, params = {}, config: {})
        response = @internal_client.post("/v1/labels/#{label_id}/return", params, config)
        response.body
      end

      # @param shipment_id [String]
      # @param params [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def create_from_shipment_id(shipment_id, params = {}, config: {})
        response = @internal_client.post("/v1/labels/shipment/#{shipment_id}", params, config)
        response.body
      end
    end
  end
end
