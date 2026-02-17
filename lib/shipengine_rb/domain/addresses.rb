# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Addresses
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param addresses [Array<Hash>]
      # @param config [Hash?]
      # @return [Array<Hash>]
      def validate(addresses, config: {})
        addresses_array = addresses.map { |addr| addr.is_a?(Hash) ? addr.compact : addr }
        response = @internal_client.post('/v1/addresses/validate', addresses_array, config)
        response.body
      end

      # @param text [Hash] - body with text to parse
      # @param config [Hash?]
      # @return [Hash]
      def parse(text, config: {})
        response = @internal_client.put('/v1/addresses/recognize', text, config)
        response.body
      end
    end
  end
end
