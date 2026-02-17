# frozen_string_literal: true

require_relative 'carriers/list_carriers'
require 'shipengine/constants'

module ShipEngine
  module Domain
    class Carriers
      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      def list_carriers(config:)
        response = @internal_client.get('/v1/carriers', {}, config)
        result = response.body

        carriers = (result['carriers'] || []).map do |carrier|
          services = (carrier['services'] || []).map do |service|
            ListCarriers::Carrier::Service.new(
              carrier_id: service['carrier_id'],
              carrier_code: service['carrier_code'],
              service_code: service['service_code'],
              name: service['name'],
              domestic: service['domestic'],
              international: service['international'],
              is_multi_package_supported: service['is_multi_package_supported']
            )
          end

          packages = (carrier['packages'] || []).map do |package|
            dimensions = nil
            if package['dimensions']
              dims = package['dimensions']
              dimensions = ListCarriers::Carrier::Package::Dimensions.new(
                unit: dims['unit'],
                length: dims['length'],
                width: dims['width'],
                height: dims['height']
              )
            end
            ListCarriers::Carrier::Package.new(
              package_id: package['package_id'],
              package_code: package['package_code'],
              name: package['name'],
              dimensions:,
              description: package['description']
            )
          end

          options = (carrier['options'] || []).map do |option|
            ListCarriers::Carrier::Option.new(
              name: option['name'],
              default_value: option['default_value'],
              description: option['description']
            )
          end

          ListCarriers::Carrier.new(
            carrier_id: carrier['carrier_id'],
            carrier_code: carrier['carrier_code'],
            account_number: carrier['account_number'],
            requires_funded_amount: carrier['requires_funded_amount'],
            balance: carrier['balance'],
            nickname: carrier['nickname'],
            friendly_name: carrier['friendly_name'],
            primary: carrier['primary'],
            has_multi_package_supporting_services: carrier['has_multi_package_supporting_services'],
            supports_label_messages: carrier['supports_label_messages'],
            services:,
            packages:,
            options:
          )
        end

        errors = (result['errors'] || []).map do |error|
          ListCarriers::Error.new(
            error_source: error['error_source'],
            error_type: error['error_type'],
            error_code: error['error_code'],
            message: error['message']
          )
        end

        ListCarriers::Response.new(
          carriers:,
          request_id: result['request_id'],
          errors:
        )
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(carrier_id, config:)
        response = @internal_client.get("/v1/carriers/#{carrier_id}", {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def disconnect(carrier_id, config:)
        response = @internal_client.delete("/v1/carriers/#{carrier_id}", {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param amount [Hash] - { currency:, amount: }
      # @param config [Hash?]
      # @return [Hash]
      def add_funds(carrier_id, amount, config:)
        response = @internal_client.put("/v1/carriers/#{carrier_id}/add_funds", amount, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def list_services(carrier_id, config:)
        response = @internal_client.get("/v1/carriers/#{carrier_id}/services", {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def list_packages(carrier_id, config:)
        response = @internal_client.get("/v1/carriers/#{carrier_id}/packages", {}, config)
        response.body
      end

      # @param carrier_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def list_options(carrier_id, config:)
        response = @internal_client.get("/v1/carriers/#{carrier_id}/options", {}, config)
        response.body
      end
    end
  end
end
