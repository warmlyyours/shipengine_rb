# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Documents domain for creating and managing shipping documents.
    # Supports combined label documents that merge multiple labels into a single file.
    class Documents
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Creates a combined document from multiple labels (e.g., for batch printing).
      #
      # @param params [Hash] combined label options (label_ids, format, layout, etc.)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] document metadata with download URL or href for the combined file
      # @example
      #   doc = client.documents.create_combined_label_document({ label_ids: ["se_1", "se_2"], format: "pdf" })
      def create_combined_label_document(params, config: {})
        @internal_client.post('/v1/documents/combined_labels', params, config)
      end
    end
  end
end
