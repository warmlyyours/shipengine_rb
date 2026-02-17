# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Tokens
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def get_ephemeral_token(config: {})
        @internal_client.post('/v1/tokens/ephemeral', {}, config)
      end
    end
  end
end
