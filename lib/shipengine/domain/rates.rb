# frozen_string_literal: true

require_relative 'rates/get_with_shipment_details'

module ShipEngine
  module Domain
    class Rates
      require 'shipengine/constants'

      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param shipment_details [Hash]
      # @param config [Hash?]
      #
      # @return [ShipEngine::Domain::Rates::GetWithShipmentDetails::Response]
      def get_rates_with_shipment_details(shipment_details, config)
        response = @internal_client.post('/v1/rates', shipment_details, config)
        r = response.body

        items = (r['items'] || []).map do |item|
          GetWithShipmentDetails::Response::Item.new(
            name: item['name'], sales_order_id: item['sales_order_id'],
            sales_order_item_id: item['sales_order_item_id'], quantity: item['quantity'],
            sku: item['sku'], external_order_id: item['external_order_id'],
            external_order_item_id: item['external_order_item_id'],
            asin: item['asin'], order_source_code: item['order_source_code']
          )
        end

        tax_identifiers = nil
        if r['tax_identifiers']
          tax_identifiers = r['tax_identifiers'].map do |ti|
            GetWithShipmentDetails::Response::TaxIdentifier.new(
              taxable_entity_type: ti['taxable_entity_type'],
              identifier_type: ti['identifier_type'],
              issuing_authority: ti['issuing_authority'],
              value: ti['value']
            )
          end
        end

        tags = (r['tags'] || []).map do |tag|
          GetWithShipmentDetails::Response::Tag.new(name: tag['name'])
        end

        packages = (r['packages'] || []).map { |pkg| build_package(pkg) }

        customs = build_customs(r['customs'])

        ship_to = build_address(r['ship_to'])
        ship_from = build_address(r['ship_from'])
        return_to = build_address(r['return_to'])

        advanced_options = build_advanced_options(r['advanced_options'])

        total_weight = nil
        if r['total_weight']
          total_weight = GetWithShipmentDetails::Response::Weight.new(
            value: r['total_weight']['value'], unit: r['total_weight']['unit']
          )
        end

        rate_resp = r['rate_response']
        rates = (rate_resp['rates'] || []).map { |rate| build_rate(rate) }
        invalid_rates = (rate_resp['invalid_rates'] || []).map { |rate| build_rate(rate) }

        errors = (rate_resp['errors'] || []).map do |error|
          GetWithShipmentDetails::Response::RateResponse::Error.new(
            error_source: error['error_source'], error_type: error['error_type'],
            error_code: error['error_code'], message: error['message']
          )
        end

        rate_response = GetWithShipmentDetails::Response::RateResponse.new(
          rates:, invalid_rates:,
          rate_request_id: rate_resp['rate_request_id'],
          shipment_id: rate_resp['shipment_id'],
          created_at: rate_resp['created_at'],
          status: rate_resp['status'],
          errors:
        )

        GetWithShipmentDetails::Response.new(
          shipment_id: r['shipment_id'], carrier_id: r['carrier_id'],
          service_code: r['service_code'], external_order_id: r['external_order_id'],
          items:, tax_identifiers:,
          external_shipment_id: r['external_shipment_id'],
          ship_date: r['ship_date'], created_at: r['created_at'],
          modified_at: r['modified_at'], shipment_status: r['shipment_status'],
          ship_to:, ship_from:, warehouse_id: r['warehouse_id'],
          return_to:, confirmation: r['confirmation'],
          customs:, advanced_options:, origin_type: r['origin_type'],
          insurance_provider: r['insurance_provider'], tags:,
          order_source_code: r['order_source_code'], packages:,
          total_weight:, rate_response:
        )
      end

      # @param shipment_details [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def estimate(shipment_details, config)
        response = @internal_client.post('/v1/rates/estimate', shipment_details, config)
        response.body
      end

      # @param rate_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(rate_id, config)
        response = @internal_client.get("/v1/rates/#{rate_id}", {}, config)
        response.body
      end

      # @param params [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def bulk(params, config)
        response = @internal_client.post('/v1/rates/bulk', params, config)
        response.body
      end

      private

      def build_address(addr)
        return nil unless addr

        GetWithShipmentDetails::Response::Address.new(
          address_line1: addr['address_line1'], address_line2: addr['address_line2'],
          address_line3: addr['address_line3'], name: addr['name'],
          company_name: addr['company_name'], phone: addr['phone'],
          city_locality: addr['city_locality'], state_province: addr['state_province'],
          postal_code: addr['postal_code'], country_code: addr['country_code'],
          address_residential_indicator: addr['address_residential_indicator']
        )
      end

      def build_package(pkg)
        weight = GetWithShipmentDetails::Response::Weight.new(
          value: pkg.dig('weight', 'value'), unit: pkg.dig('weight', 'unit')
        )

        dimensions = nil
        if pkg['dimensions']
          d = pkg['dimensions']
          dimensions = GetWithShipmentDetails::Response::Dimensions.new(
            unit: d['unit'], length: d['length'], width: d['width'], height: d['height']
          )
        end

        insured_value = nil
        if pkg['insured_value']
          iv = pkg['insured_value']
          insured_value = GetWithShipmentDetails::Response::MonetaryValue.new(
            currency: iv['currency'], amount: iv['amount']
          )
        end

        label_messages = nil
        if pkg['label_messages']
          lm = pkg['label_messages']
          label_messages = GetWithShipmentDetails::Response::Package::LabelMessages.new(
            reference1: lm['reference1'], reference2: lm['reference2'], reference3: lm['reference3']
          )
        end

        GetWithShipmentDetails::Response::Package.new(
          package_code: pkg['package_code'], weight:, dimensions:, insured_value:,
          tracking_number: pkg['tracking_number'], label_messages:, external_package_id: pkg['external_package_id']
        )
      end

      def build_customs(customs_hash)
        return nil unless customs_hash&.dig('customs_items')

        customs_items = customs_hash['customs_items'].map do |ci|
          value = nil
          if ci['value']
            value = GetWithShipmentDetails::Response::MonetaryValue.new(
              currency: ci['value']['currency'], amount: ci['value']['amount']
            )
          end

          GetWithShipmentDetails::Response::Customs::CustomsItem.new(
            customs_item_id: ci['customs_item_id'], description: ci['description'],
            quantity: ci['quantity'], value:,
            harmonized_tariff_code: ci['harmonized_tariff_code'],
            country_of_origin: ci['country_of_origin'],
            unit_of_measure: ci['unit_of_measure'],
            sku: ci['sku'], sku_description: ci['sku_description']
          )
        end

        GetWithShipmentDetails::Response::Customs.new(
          contents: customs_hash['contents'],
          non_delivery: customs_hash['non_delivery'],
          customs_items:
        )
      end

      def build_advanced_options(ao)
        return nil unless ao

        dry_ice_weight = nil
        if ao['dry_ice_weight']
          dry_ice_weight = GetWithShipmentDetails::Response::Weight.new(
            value: ao['dry_ice_weight']['value'], unit: ao['dry_ice_weight']['unit']
          )
        end

        collect_on_delivery = nil
        if ao['collect_on_delivery']
          cod = ao['collect_on_delivery']
          payment_amount = nil
          if cod['payment_amount']
            payment_amount = GetWithShipmentDetails::Response::MonetaryValue.new(
              currency: cod['payment_amount']['currency'],
              amount: cod['payment_amount']['amount']
            )
          end
          collect_on_delivery = GetWithShipmentDetails::Response::AdvancedOptions::CollectOnDelivery.new(
            payment_type: cod['payment_type'], payment_amount:
          )
        end

        GetWithShipmentDetails::Response::AdvancedOptions.new(
          bill_to_account: ao['bill_to_account'],
          bill_to_country_code: ao['bill_to_country_code'],
          bill_to_party: ao['bill_to_party'],
          bill_to_postal_code: ao['bill_to_postal_code'],
          contains_alcohol: ao['contains_alcohol'],
          delivered_duty_paid: ao['delivered_duty_paid'],
          dry_ice: ao['dry_ice'], dry_ice_weight:,
          non_machinable: ao['non_machinable'],
          saturday_delivery: ao['saturday_delivery'],
          use_ups_ground_freight_pricing: ao['use_ups_ground_freight_pricing'],
          freight_class: ao['freight_class'],
          custom_field1: ao['custom_field1'],
          custom_field2: ao['custom_field2'],
          custom_field3: ao['custom_field3'],
          origin_type: ao['origin_type'],
          shipper_release: ao['shipper_release'],
          collect_on_delivery:
        )
      end

      def build_rate(rate)
        tax_amount = nil
        if rate['tax_amount']
          tax_amount = GetWithShipmentDetails::Response::MonetaryValue.new(
            currency: rate['tax_amount']['currency'], amount: rate['tax_amount']['amount']
          )
        end

        GetWithShipmentDetails::Response::RateResponse::Rate.new(
          rate_id: rate['rate_id'], rate_type: rate['rate_type'],
          carrier_id: rate['carrier_id'],
          shipping_amount: GetWithShipmentDetails::Response::MonetaryValue.new(
            currency: rate.dig('shipping_amount', 'currency'), amount: rate.dig('shipping_amount', 'amount')
          ),
          insurance_amount: GetWithShipmentDetails::Response::MonetaryValue.new(
            currency: rate.dig('insurance_amount', 'currency'), amount: rate.dig('insurance_amount', 'amount')
          ),
          confirmation_amount: GetWithShipmentDetails::Response::MonetaryValue.new(
            currency: rate.dig('confirmation_amount', 'currency'), amount: rate.dig('confirmation_amount', 'amount')
          ),
          other_amount: GetWithShipmentDetails::Response::MonetaryValue.new(
            currency: rate.dig('other_amount', 'currency'), amount: rate.dig('other_amount', 'amount')
          ),
          tax_amount:, zone: rate['zone'], package_type: rate['package_type'],
          delivery_days: rate['delivery_days'], guaranteed_service: rate['guaranteed_service'],
          estimated_delivery_date: rate['estimated_delivery_date'],
          carrier_delivery_days: rate['carrier_delivery_days'],
          ship_date: rate['ship_date'], negotiated_rate: rate['negotiated_rate'],
          service_type: rate['service_type'], service_code: rate['service_code'],
          trackable: rate['trackable'], carrier_code: rate['carrier_code'],
          carrier_nickname: rate['carrier_nickname'],
          carrier_friendly_name: rate['carrier_friendly_name'],
          validation_status: rate['validation_status'],
          warning_messages: rate['warning_messages'],
          error_messages: rate['error_messages']
        )
      end
    end
  end
end
