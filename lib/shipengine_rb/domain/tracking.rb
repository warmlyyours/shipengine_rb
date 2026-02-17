# frozen_string_literal: true

module ShipEngineRb
  module Domain
    class Tracking
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param label_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def track_by_label_id(label_id, config: {})
        response = @internal_client.get("/v1/labels/#{label_id}/track", {}, config)
        response.body
      end

      # @param carrier_code [String]
      # @param tracking_number [String]
      # @param config [Hash?]
      # @return [Hash]
      def track(carrier_code, tracking_number, config: {})
        response = @internal_client.get('/v1/tracking', { carrier_code:, tracking_number: }, config)
        response.body
      end

      # @param carrier_code [String]
      # @param tracking_number [String]
      # @param config [Hash?]
      # @return [Hash]
      def start(carrier_code, tracking_number, config: {})
        response = @internal_client.post('/v1/tracking/start', { carrier_code:, tracking_number: }, config)
        response.body
      end

      # @param carrier_code [String]
      # @param tracking_number [String]
      # @param config [Hash?]
      # @return [Hash]
      def stop(carrier_code, tracking_number, config: {})
        response = @internal_client.post('/v1/tracking/stop', { carrier_code:, tracking_number: }, config)
        response.body
      end
    end
  end
end
