# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Documents
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param params [Hash] - combined label document options (label_ids, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def create_combined_label_document(params, config: {})
        response = @internal_client.post('/v1/documents/combined_labels', params, config)
        response.body
      end
    end
  end
end
