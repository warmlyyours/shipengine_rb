# frozen_string_literal: true

module ShipEngine
  module Domain
    class Tags
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def list(config: {})
        response = @internal_client.get('/v1/tags', {}, config)
        response.body
      end

      # @param tag_name [String]
      # @param config [Hash?]
      # @return [Hash]
      def create(tag_name, config: {})
        response = @internal_client.post("/v1/tags/#{tag_name}", {}, config)
        response.body
      end

      # @param tag_name [String]
      # @param config [Hash?]
      # @return [Hash]
      def delete(tag_name, config: {})
        response = @internal_client.delete("/v1/tags/#{tag_name}", {}, config)
        response.body
      end

      # @param tag_name [String]
      # @param new_tag_name [String]
      # @param config [Hash?]
      # @return [Hash]
      def rename(tag_name, new_tag_name, config: {})
        response = @internal_client.put("/v1/tags/#{tag_name}/#{new_tag_name}", {}, config)
        response.body
      end
    end
  end
end
