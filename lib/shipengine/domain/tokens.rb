# frozen_string_literal: true

module ShipEngine
  module Domain
    class Tokens
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def get_ephemeral_token(config: {})
        response = @internal_client.post('/v1/tokens/ephemeral', {}, config)
        response.body
      end
    end
  end
end
