# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Downloads
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param subpath [String] - the download path (typically from a label_download href)
      # @param config [Hash?]
      # @return [Hash]
      def download(subpath, config: {})
        response = @internal_client.get("/v1/downloads/#{subpath}", {}, config)
        response.body
      end
    end
  end
end
