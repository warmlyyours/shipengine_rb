# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Domain class for managing tags. Tags can be used to organize and filter
    # shipments and other resources.
    class Tags
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Lists all tags in the account.
      #
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the list of tags.
      #
      # @example
      #   client.tags.list
      def list(config: {})
        response = @internal_client.get('/v1/tags', {}, config)
        response.body
      end

      # Creates a new tag.
      #
      # @param tag_name [String] The name of the tag to create.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body containing the created tag.
      #
      # @example
      #   client.tags.create("priority")
      def create(tag_name, config: {})
        response = @internal_client.post("/v1/tags/#{tag_name}", {}, config)
        response.body
      end

      # Deletes a tag.
      #
      # @param tag_name [String] The name of the tag to delete.
      # @param config [Hash] Optional request configuration overrides.
      # @return [Hash] Response body confirming the deletion.
      #
      # @example
      #   client.tags.delete("priority")
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
