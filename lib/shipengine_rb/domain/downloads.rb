# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Downloads domain for retrieving files (labels, documents, manifests).
    # Use the subpath from label_download href or other download URLs.
    class Downloads
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Downloads a file by subpath (e.g., from a label's label_download href).
      #
      # @param subpath [String] the download path, typically from label_download href or document URL
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] response body containing the file data or download metadata
      # @example
      #   file = client.downloads.download("labels/123/4")
      def download(subpath, config: {})
        response = @internal_client.get("/v1/downloads/#{subpath}", {}, config)
        response.body
      end
    end
  end
end
