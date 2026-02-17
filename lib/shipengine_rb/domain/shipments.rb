# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Domain class for managing shipments. Provides methods to create, list, update,
    # cancel shipments, manage tags, parse addresses, and get shipping rates.
    class Shipments
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists shipments with optional filtering via query parameters.
      #
      # @param params [Hash] Query params (page, page_size, shipment_status, etc.).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing shipment list and pagination metadata.
      #
      # @example
      #   client.shipments.list(page: 1, page_size: 25, shipment_status: "label_purchased")
      def list(params = {}, config: {})
        response = @internal_client.get('/v1/shipments', params, config)
        response.body
      end

      # Creates a new shipment.
      #
      # @param params [Hash] Shipment details (service_code, ship_to, ship_from, packages, etc.).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the created shipment.
      #
      # @example
      #   client.shipments.create(service_code: "ups_ground", ship_to: {...}, packages: [...])
      def create(params, config: {})
        response = @internal_client.post('/v1/shipments', params, config)
        response.body
      end

      # Retrieves a shipment by its ID.
      #
      # @param shipment_id [String] The unique identifier of the shipment.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the shipment details.
      #
      # @example
      #   client.shipments.get_by_id("se-123")
      def get_by_id(shipment_id, config: {})
        response = @internal_client.get("/v1/shipments/#{shipment_id}", {}, config)
        response.body
      end

      # Updates an existing shipment.
      #
      # @param shipment_id [String] The unique identifier of the shipment to update.
      # @param params [Hash] Updated shipment details.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the updated shipment.
      #
      # @example
      #   client.shipments.update("se-123", ship_to: { address_line1: "123 New St" })
      def update(shipment_id, params, config: {})
        response = @internal_client.put("/v1/shipments/#{shipment_id}", params, config)
        response.body
      end

      # Cancels a shipment.
      #
      # @param shipment_id [String] The unique identifier of the shipment to cancel.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the cancellation.
      #
      # @example
      #   client.shipments.cancel("se-123")
      def cancel(shipment_id, config: {})
        response = @internal_client.put("/v1/shipments/#{shipment_id}/cancel", {}, config)
        response.body
      end

      # Adds a tag to a shipment.
      #
      # @param shipment_id [String] The unique identifier of the shipment.
      # @param tag_name [String] The name of the tag to add.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the tag was added.
      #
      # @example
      #   client.shipments.add_tag("se-123", "priority")
      def add_tag(shipment_id, tag_name, config: {})
        response = @internal_client.post("/v1/shipments/#{shipment_id}/tags/#{tag_name}", {}, config)
        response.body
      end

      # Removes a tag from a shipment.
      #
      # @param shipment_id [String] The unique identifier of the shipment.
      # @param tag_name [String] The name of the tag to remove.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the tag was removed.
      #
      # @example
      #   client.shipments.remove_tag("se-123", "priority")
      def remove_tag(shipment_id, tag_name, config: {})
        response = @internal_client.delete("/v1/shipments/#{shipment_id}/tags/#{tag_name}", {}, config)
        response.body
      end

      # Retrieves a shipment by its external ID (your system's reference).
      #
      # @param external_shipment_id [String] Your external reference for the shipment.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the shipment details.
      #
      # @example
      #   client.shipments.get_by_external_id("order-456")
      def get_by_external_id(external_shipment_id, config: {})
        response = @internal_client.get("/v1/shipments/external_shipment_id/#{external_shipment_id}", {}, config)
        response.body
      end

      # Parses unstructured address text into structured address components.
      #
      # @param params [Hash] Text and address data to parse.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing parsed address components.
      #
      # @example
      #   client.shipments.parse(text: "123 Main St, Austin TX 78701")
      def parse(params, config: {})
        response = @internal_client.put('/v1/shipments/recognize', params, config)
        response.body
      end

      # Gets available shipping rates for a shipment.
      #
      # @param shipment_id [String] The unique identifier of the shipment.
      # @param params [Hash] Query params (e.g., created_at_start).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing available rates from carriers.
      #
      # @example
      #   client.shipments.get_rates("se-123")
      def get_rates(shipment_id, params = {}, config: {})
        response = @internal_client.get("/v1/shipments/#{shipment_id}/rates", params, config)
        response.body
      end

      # Lists all tags associated with a shipment.
      #
      # @param shipment_id [String] The unique identifier of the shipment.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the list of tags.
      #
      # @example
      #   client.shipments.list_tags("se-123")
      def list_tags(shipment_id, config: {})
        response = @internal_client.get("/v1/shipments/#{shipment_id}/tags", {}, config)
        response.body
      end

      # Bulk updates tags across multiple shipments.
      #
      # @param params [Hash] Bulk tag update body (shipment_ids, tags to add/remove).
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the tag updates.
      #
      # @example
      #   client.shipments.update_tags(shipment_ids: ["se-123"], tags: [{ name: "priority" }])
      def update_tags(params, config: {})
        response = @internal_client.put('/v1/shipments/tags', params, config)
        response.body
      end
    end
  end
end
