# frozen_string_literal: true

module ShipEngineRb
  module Domain
    # Address validation and parsing. Validates mailing addresses and parses
    # addresses from free-form text.
    #
    # @example Basic usage
    #   client = ShipEngineRb::Client.new("YOUR_API_KEY")
    #   validated = client.addresses.validate([{ name: "John", address_line1: "123 Main St", city: "Austin", state: "TX", postal_code: "78701", country_code: "US" }])
    #   parsed = client.addresses.parse({ text: "123 Main St, Austin, TX 78701" })
    #
    # @see https://shipengine.github.io/shipengine-openapi/
    class Addresses
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # Validates an array of address hashes. Returns validated/corrected addresses
      # with suggestions for invalid or ambiguous addresses.
      #
      # @param addresses [Array<Hash>] Array of address hashes to validate (e.g. name, address_line1, city, state, postal_code, country_code).
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Array<Hash>] Array of validated address results with status, original address, and suggested corrections.
      # @example
      #   result = client.addresses.validate([
      #     { name: "John Doe", address_line1: "123 Main St", city: "Austin", state: "TX", postal_code: "78701", country_code: "US" }
      #   ])
      # @see https://shipengine.github.io/shipengine-openapi/
      def validate(addresses, config: {})
        addresses_array = addresses.map { |addr| addr.is_a?(Hash) ? addr.compact : addr }
        response = @internal_client.post('/v1/addresses/validate', addresses_array, config)
        response.body
      end

      # Parses an address from free-form text. Recognizes and extracts address
      # components (street, city, state, postal code, country) from unstructured text.
      #
      # @param text [Hash] Request body with text to parse (e.g. { text: "123 Main St, Austin, TX 78701" }).
      # @param config [Hash] Optional request configuration (e.g. idempotency_key).
      # @return [Hash] Parsed address with structured components (address_line1, city, state, postal_code, country_code, etc.).
      # @example
      #   result = client.addresses.parse({ text: "123 Main St, Austin, TX 78701" })
      # @see https://shipengine.github.io/shipengine-openapi/
      def parse(text, config: {})
        response = @internal_client.put('/v1/addresses/recognize', text, config)
        response.body
      end
    end
  end
end
