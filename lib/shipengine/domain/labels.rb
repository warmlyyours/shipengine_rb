# frozen_string_literal: true

require_relative 'labels/create_from_rate'
require_relative 'labels/create_from_shipment_details'
require_relative 'labels/void_label'

module ShipEngine
  module Domain
    class Labels
      require 'shipengine/constants'

      # @param [ShipEngine::InternalClient] internal_client
      def initialize(internal_client)
        @internal_client = internal_client
      end

      # @param rate_id [String]
      # @param params [Hash]
      # @param config [Hash?]
      #
      # @return [ShipEngine::Domain::Labels::CreateFromRate::Response]
      #
      # @see https://shipengine.github.io/shipengine-openapi/#operation/create_label_from_rate
      def create_from_rate(rate_id, params, config)
        response = @internal_client.post("/v1/labels/rates/#{rate_id}", params, config)
        r = response.body

        CreateFromRate::Response.new(
          **build_label_fields(r, CreateFromRate::Response)
        )
      end

      # @param params [Hash]
      # @param config [Hash?]
      #
      # @return [ShipEngine::Domain::Labels::CreateFromShipmentDetails::Response]
      #
      # @see https://shipengine.github.io/shipengine-openapi/#operation/create_label
      def create_from_shipment_details(params, config)
        response = @internal_client.post('/v1/labels', params, config)
        r = response.body

        CreateFromShipmentDetails::Response.new(
          **build_label_fields(r, CreateFromShipmentDetails::Response)
        )
      end

      # @param label_id [String]
      # @param config [Hash?]
      #
      # @return [ShipEngine::Domain::Labels::VoidLabel::Response]
      #
      # @see https://shipengine.github.io/shipengine-openapi/#operation/void_label
      def void(label_id, config)
        response = @internal_client.put("/v1/labels/#{label_id}/void", {}, config)
        r = response.body

        VoidLabel::Response.new(
          approved: r['approved'],
          message: r['message']
        )
      end

      # @param params [Hash] - query params (e.g. page, page_size, label_status, etc.)
      # @param config [Hash?]
      # @return [Hash]
      def list(params, config)
        response = @internal_client.get('/v1/labels', params, config)
        response.body
      end

      # @param label_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_id(label_id, config)
        response = @internal_client.get("/v1/labels/#{label_id}", {}, config)
        response.body
      end

      # @param external_shipment_id [String]
      # @param config [Hash?]
      # @return [Hash]
      def get_by_external_shipment_id(external_shipment_id, config)
        response = @internal_client.get("/v1/labels/external_shipment_id/#{external_shipment_id}", {}, config)
        response.body
      end

      # @param label_id [String]
      # @param params [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def create_return_label(label_id, params, config)
        response = @internal_client.post("/v1/labels/#{label_id}/return", params, config)
        response.body
      end

      # @param shipment_id [String]
      # @param params [Hash]
      # @param config [Hash?]
      # @return [Hash]
      def create_from_shipment_id(shipment_id, params, config)
        response = @internal_client.post("/v1/labels/shipment/#{shipment_id}", params, config)
        response.body
      end

      private

      def build_label_fields(r, response_mod)
        shipment_cost = build_monetary_value(r['shipment_cost'], response_mod)
        insurance_cost = build_monetary_value(r['insurance_cost'], response_mod)

        label_download = nil
        if r['label_download']
          dl = r['label_download']
          label_download = response_mod::LabelDownload.new(
            href: dl['href'], pdf: dl['pdf'], png: dl['png'], zpl: dl['zpl']
          )
        end

        form_download = nil
        if r['form_download']
          fd = r['form_download']
          form_download = response_mod::FormDownload.new(href: fd['href'], type: fd['type'])
        end

        insurance_claim = nil
        if r['insurance_claim']
          ic = r['insurance_claim']
          insurance_claim = response_mod::InsuranceClaim.new(href: ic['href'], type: ic['type'])
        end

        packages = (r['packages'] || []).map do |pkg|
          weight = response_mod::Weight.new(value: pkg.dig('weight', 'value'), unit: pkg.dig('weight', 'unit'))

          dimensions = nil
          if pkg['dimensions']
            d = pkg['dimensions']
            dimensions = response_mod::Dimensions.new(unit: d['unit'], length: d['length'], width: d['width'], height: d['height'])
          end

          insured_value = build_monetary_value(pkg['insured_value'], response_mod)

          label_messages = nil
          if pkg['label_messages']
            lm = pkg['label_messages']
            label_messages = response_mod::Package::LabelMessages.new(
              reference1: lm['reference1'], reference2: lm['reference2'], reference3: lm['reference3']
            )
          end

          response_mod::Package.new(
            package_code: pkg['package_code'], weight:, dimensions:, insured_value:,
            tracking_number: pkg['tracking_number'], label_messages:, external_package_id: pkg['external_package_id']
          )
        end

        {
          label_id: r['label_id'], status: r['status'], shipment_id: r['shipment_id'],
          ship_date: r['ship_date'], created_at: r['created_at'], shipment_cost:, insurance_cost:,
          tracking_number: r['tracking_number'], is_return_label: r['is_return_label'],
          rma_number: r['rma_number'], is_international: r['is_international'],
          batch_id: r['batch_id'], carrier_id: r['carrier_id'], charge_event: r['charge_event'],
          service_code: r['service_code'], package_code: r['package_code'],
          voided: r['voided'], voided_at: r['voided_at'], label_format: r['label_format'],
          display_scheme: r['display_scheme'], label_layout: r['label_layout'],
          trackable: r['trackable'], label_image_id: r['label_image_id'],
          carrier_code: r['carrier_code'], tracking_status: r['tracking_status'],
          label_download:, form_download:, insurance_claim:, packages:
        }
      end

      def build_monetary_value(hash, response_mod)
        return nil unless hash

        response_mod::MonetaryValue.new(currency: hash['currency'], amount: hash['amount'])
      end
    end
  end
end
