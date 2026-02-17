# frozen_string_literal: true

module ShipEngine
  module Domain
    class Insurance
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param config [Hash?]
      # @return [Hash]
      def get_balance(config: {})
        response = @internal_client.get('/v1/insurance/shipsurance/balance', {}, config)
        response.body
      end

      # @param params [Hash] - { currency:, amount: }
      # @param config [Hash?]
      # @return [Hash]
      def add_funds(params, config: {})
        response = @internal_client.patch('/v1/insurance/shipsurance/add_funds', params, config)
        response.body
      end

      # @param config [Hash?]
      # @return [Hash]
      def connect(config: {})
        response = @internal_client.post('/v1/connections/insurance/shipsurance', {}, config)
        response.body
      end

      # @param config [Hash?]
      # @return [Hash]
      def disconnect(config: {})
        response = @internal_client.delete('/v1/connections/insurance/shipsurance', {}, config)
        response.body
      end
    end
  end
end
