# frozen_string_literal: true

module ShipEngine
  module Domain
    class Account
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def get_settings(config: {})
        response = @internal_client.get('/v1/account/settings', {}, config)
        response.body
      end

      # @param params [Hash] - account settings
      # @param config [Hash?]
      # @return [Hash]
      def update_settings(params, config: {})
        response = @internal_client.put('/v1/account/settings', params, config)
        response.body
      end

      # @param config [Hash?]
      # @return [Hash]
      def list_images(config: {})
        response = @internal_client.get('/v1/account/settings/images', {}, config)
        response.body
      end

      # @param image_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_image(image_id, config: {})
        response = @internal_client.get("/v1/account/settings/images/#{image_id}", {}, config)
        response.body
      end

      # @param params [Hash] - image details
      # @param config [Hash?]
      # @return [Hash]
      def create_image(params, config: {})
        response = @internal_client.post('/v1/account/settings/images', params, config)
        response.body
      end

      # @param image_id [String]
      # @param params [Hash] - updated image details
      # @param config [Hash?]
      # @return [Hash]
      def update_image(image_id, params, config: {})
        response = @internal_client.put("/v1/account/settings/images/#{image_id}", params, config)
        response.body
      end

      # @param image_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def delete_image(image_id, config: {})
        response = @internal_client.delete("/v1/account/settings/images/#{image_id}", {}, config)
        response.body
      end
    end
  end
end
