# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Account domain for managing ShipEngine account settings and images.
    # Provides access to account configuration, branding images for labels,
    # and related account-level operations.
    class Account
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Retrieves the current account settings.
      #
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] account settings including default label format, units, and other preferences
      # @example
      #   settings = client.account.get_settings
      #   puts settings[:default_label_format]
      def get_settings(config: {})
        @internal_client.get('/v1/account/settings', {}, config)
      end

      # Updates the account settings with the provided values.
      #
      # @param params [Hash] account settings to update (e.g., default_label_format, units)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] the updated account settings
      # @example
      #   settings = client.account.update_settings({ default_label_format: "pdf" })
      def update_settings(params, config: {})
        @internal_client.put('/v1/account/settings', params, config)
      end

      # Lists all images configured for the account (e.g., logo for labels).
      #
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] list of image records with id, name, type, and other metadata
      # @example
      #   images = client.account.list_images
      #   images[:images].each { |img| puts img[:image_id] }
      def list_images(config: {})
        @internal_client.get('/v1/account/settings/images', {}, config)
      end

      # Retrieves a single image by ID.
      #
      # @param image_id [String] the unique identifier of the image
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] image details including image_id, name, type, and URL
      # @example
      #   image = client.account.get_image("img_abc123")
      def get_image(image_id, config: {})
        @internal_client.get("/v1/account/settings/images/#{image_id}", {}, config)
      end

      # Creates a new image for use on labels (e.g., logo).
      #
      # @param params [Hash] image details (e.g., name, type, image_data base64)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] the created image record with image_id and metadata
      # @example
      #   image = client.account.create_image({ name: "Logo", type: "label", image_data: "base64..." })
      def create_image(params, config: {})
        @internal_client.post('/v1/account/settings/images', params, config)
      end

      # Updates an existing image.
      #
      # @param image_id [String] the unique identifier of the image to update
      # @param params [Hash] updated image details (e.g., name, image_data)
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] the updated image record
      # @example
      #   image = client.account.update_image("img_abc123", { name: "New Logo" })
      def update_image(image_id, params, config: {})
        @internal_client.put("/v1/account/settings/images/#{image_id}", params, config)
      end

      # Deletes an image from the account.
      #
      # @param image_id [String] the unique identifier of the image to delete
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] empty response or confirmation of deletion
      # @example
      #   client.account.delete_image("img_abc123")
      def delete_image(image_id, config: {})
        @internal_client.delete("/v1/account/settings/images/#{image_id}", {}, config)
      end
    end
  end
end
