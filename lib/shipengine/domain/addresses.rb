# frozen_string_literal: true

require_relative 'addresses/address_validation'

module ShipEngine
  module Domain
    class Addresses
      require 'shipengine/constants'

      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param addresses [Array<Hash>]
      # @param config [Hash?]
      #
      # @return [Array<ShipEngine::Domain::Addresses::AddressValidation::Response>]
      #
      # @see https://shipengine.github.io/shipengine-openapi/#operation/validate_address
      def validate(addresses, config)
        addresses_array = addresses.map { it.is_a?(Hash) ? it.compact : it }

        response = @internal_client.post('/v1/addresses/validate', addresses_array, config)
        address_api_result = response.body

        address_api_result.map do |result|
          orig = result['original_address']
          normalized_original_address_api_result = AddressValidation::Address.new(
            address_line1: orig['address_line1'],
            address_line2: orig['address_line2'],
            address_line3: orig['address_line3'],
            name: orig['name'],
            company_name: orig['company_name'],
            phone: orig['phone'],
            city_locality: orig['city_locality'],
            state_province: orig['state_province'],
            postal_code: orig['postal_code'],
            country_code: orig['country_code'],
            address_residential_indicator: orig['address_residential_indicator']
          )

          normalized_matched_address_api_result = if result['matched_address']
                                                    matched = result['matched_address']
                                                    AddressValidation::Address.new(
                                                      address_line1: matched['address_line1'],
                                                      address_line2: matched['address_line2'],
                                                      address_line3: matched['address_line3'],
                                                      name: matched['name'],
                                                      company_name: matched['company_name'],
                                                      phone: matched['phone'],
                                                      city_locality: matched['city_locality'],
                                                      state_province: matched['state_province'],
                                                      postal_code: matched['postal_code'],
                                                      country_code: matched['country_code'],
                                                      address_residential_indicator: matched['address_residential_indicator']
                                                    )
                                                  end

          status = result['status']

          messages_classes = (result['messages'] || []).map do |msg|
            AddressValidation::Message.new(type: msg['type'], code: msg['code'], message: msg['message'])
          end

          AddressValidation::Response.new(
            status:,
            messages: messages_classes,
            original_address: normalized_original_address_api_result,
            matched_address: normalized_matched_address_api_result
          )
        end
      end

      # @param text [Hash] - body with text to parse
      # @param config [Hash?]
      #
      # @return [Hash] parsed address response
      #
      # @see https://shipengine.github.io/shipengine-openapi/#operation/parse_address
      def parse(text, config)
        response = @internal_client.put('/v1/addresses/recognize', text, config)
        response.body
      end
    end
  end
end
