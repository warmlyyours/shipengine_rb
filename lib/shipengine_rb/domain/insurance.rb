# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Insurance
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

      # Connects Shipsurance insurance to your ShipEngine account.
      #
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] connection result with status
      # @example
      #   result = client.insurance.connect
      def connect(config: {})
        response = @internal_client.post('/v1/connections/insurance/shipsurance', {}, config)
        response.body
      end

      # Disconnects Shipsurance insurance from your ShipEngine account.
      #
      # @param config [Hash] optional request configuration (e.g., idempotency_key)
      # @return [Hash] empty response or confirmation of disconnection
      # @example
      #   client.insurance.disconnect
      def disconnect(config: {})
        response = @internal_client.delete('/v1/connections/insurance/shipsurance', {}, config)
        response.body
      end
    end
  end
end
