# frozen_string_literal: true

require 'test_helper'

describe 'Get rate with shipment details: Functional test' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'handles unauthorized errors' do
    params = {
      rate_options: {
        carrier_ids: ['se-123890']
      },
      shipment: {
        validate_address: 'no_validation',
        ship_to: {
          name: 'Amanda Miller',
          phone: '555-555-5555',
          address_line1: '525 S Winchester Blvd',
          city_locality: 'San Jose',
          state_province: 'CA',
          postal_code: '95128',
          country_code: 'US',
          address_residential_indicator: 'yes'
        },
        ship_from: {
          company_name: 'Example Corp.',
          name: 'John Doe',
          phone: '111-111-1111',
          address_line1: '4009 Marathon Blvd',
          address_line2: 'Suite 300',
          city_locality: 'Austin',
          state_province: 'TX',
          postal_code: '78756',
          country_code: 'US',
          address_residential_indicator: 'no'
        },
        packages: [
          {
            weight: {
              value: 1.0,
              unit: 'ounce'
            }
          }
        ]
      }
    }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/rates')
           .to_return(status: 401, body: {
             'request_id' => 'cdc19c7b-eec7-4730-8814-462623a62ddb',
             'errors' => [{
               'error_source' => 'shipengine',
               'error_type' => 'security',
               'error_code' => 'unauthorized',
               'message' => 'The API key is invalid. Please see https://www.shipengine.com/docs/auth'
             }]
           }.to_json)

    expected_err = {
      source: 'shipengine',
      type: 'security',
      code: 'unauthorized',
      message: 'The API key is invalid. Please see https://www.shipengine.com/docs/auth'
    }

    assert_raises_shipengine(ShipEngineRb::Exceptions::ShipEngineError, expected_err) do
      client.rates.get_with_shipment_details(params)
      assert_requested(stub, times: 1)
    end
  end

  it 'handles a successful response for get_rates_with_shipment_details' do
    params = {
      rate_options: {
        carrier_ids: ['se-123890']
      },
      shipment: {
        validate_address: 'no_validation',
        ship_to: {
          name: 'Amanda Miller',
          phone: '555-555-5555',
          address_line1: '525 S Winchester Blvd',
          city_locality: 'San Jose',
          state_province: 'CA',
          postal_code: '95128',
          country_code: 'US',
          address_residential_indicator: 'yes'
        },
        ship_from: {
          company_name: 'Example Corp.',
          name: 'John Doe',
          phone: '111-111-1111',
          address_line1: '4009 Marathon Blvd',
          address_line2: 'Suite 300',
          city_locality: 'Austin',
          state_province: 'TX',
          postal_code: '78756',
          country_code: 'US',
          address_residential_indicator: 'no'
        },
        packages: [
          {
            weight: {
              value: 1.0,
              unit: 'ounce'
            }
          }
        ]
      }
    }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/rates')
           .to_return(status: 200, body: {
             shipment_id: 'se-28529731',
             carrier_id: 'se-28529731',
             service_code: 'usps_first_class_mail',
             external_order_id: 'string',
             items: [],
             tax_identifiers: [
               {
                 taxable_entity_type: 'shipper',
                 identifier_type: 'vat',
                 issuing_authority: 'string',
                 value: 'string'
               }
             ],
             external_shipment_id: 'string',
             ship_date: '2018-09-23T00:00:00.000Z',
             created_at: '2018-09-23T15:00:00.000Z',
             modified_at: '2018-09-23T15:00:00.000Z',
             shipment_status: 'pending',
             ship_to: {
               name: 'John Doe',
               phone: '+1 204-253-9411 ext. 123',
               company_name: 'The Home Depot',
               address_line1: '1999 Bishop Grandin Blvd.',
               address_line2: 'Unit 408',
               address_line3: 'Building #7',
               city_locality: 'Winnipeg',
               state_province: 'Manitoba',
               postal_code: '78756-3717',
               country_code: 'CA',
               address_residential_indicator: 'no'
             },
             ship_from: {
               name: 'John Doe',
               phone: '+1 204-253-9411 ext. 123',
               company_name: 'The Home Depot',
               address_line1: '1999 Bishop Grandin Blvd.',
               address_line2: 'Unit 408',
               address_line3: 'Building #7',
               city_locality: 'Winnipeg',
               state_province: 'Manitoba',
               postal_code: '78756-3717',
               country_code: 'CA',
               address_residential_indicator: 'no'
             },
             warehouse_id: 'se-28529731',
             return_to: {
               name: 'John Doe',
               phone: '+1 204-253-9411 ext. 123',
               company_name: 'The Home Depot',
               address_line1: '1999 Bishop Grandin Blvd.',
               address_line2: 'Unit 408',
               address_line3: 'Building #7',
               city_locality: 'Winnipeg',
               state_province: 'Manitoba',
               postal_code: '78756-3717',
               country_code: 'CA',
               address_residential_indicator: 'no'
             },
             confirmation: 'none',
             customs: {
               contents: 'merchandise',
               non_delivery: 'return_to_sender',
               customs_items: []
             },
             advanced_options: {
               bill_to_account: nil,
               bill_to_country_code: 'CA',
               bill_to_party: 'recipient',
               bill_to_postal_code: nil,
               contains_alcohol: false,
               delivered_duty_paid: false,
               dry_ice: false,
               dry_ice_weight: {
                 value: 0,
                 unit: 'pound'
               },
               non_machinable: false,
               saturday_delivery: false,
               use_ups_ground_freight_pricing: nil,
               freight_class: 77.5,
               custom_field1: nil,
               custom_field2: nil,
               custom_field3: nil,
               origin_type: 'pickup',
               shipper_release: nil,
               collect_on_delivery: {
                 payment_type: 'any',
                 payment_amount: {
                   currency: 'usd',
                   amount: 0
                 }
               }
             },
             origin_type: 'pickup',
             insurance_provider: 'none',
             tags: [],
             order_source_code: 'amazon_ca',
             packages: [
               {
                 package_code: 'small_flat_rate_box',
                 weight: {
                   value: 0,
                   unit: 'pound'
                 },
                 dimensions: {
                   unit: 'inch',
                   length: 0,
                   width: 0,
                   height: 0
                 },
                 insured_value: {
                   '0': {
                     currency: 'usd',
                     amount: 0
                   },
                   currency: 'usd',
                   amount: 0
                 },
                 tracking_number: '1Z932R800392060079',
                 label_messages: {
                   reference1: nil,
                   reference2: nil,
                   reference3: nil
                 },
                 external_package_id: 'string'
               }
             ],
             total_weight: {
               value: 0,
               unit: 'pound'
             },
             rate_response: {
               rates: [
                 {
                   rate_id: 'se-28529731',
                   rate_type: 'check',
                   carrier_id: 'se-28529731',
                   shipping_amount: {
                     currency: 'usd',
                     amount: 0
                   },
                   insurance_amount: {
                     currency: 'usd',
                     amount: 0
                   },
                   confirmation_amount: {
                     currency: 'usd',
                     amount: 0
                   },
                   other_amount: {
                     currency: 'usd',
                     amount: 0
                   },
                   tax_amount: {
                     currency: 'usd',
                     amount: 0
                   },
                   zone: 6,
                   package_type: 'package',
                   delivery_days: 5,
                   guaranteed_service: true,
                   estimated_delivery_date: '2018-09-23T00:00:00.000Z',
                   carrier_delivery_days: 'string',
                   ship_date: '2021-07-23T14:49:13Z',
                   negotiated_rate: true,
                   service_type: 'string',
                   service_code: 'string',
                   trackable: true,
                   carrier_code: 'string',
                   carrier_nickname: 'string',
                   carrier_friendly_name: 'string',
                   validation_status: 'valid',
                   warning_messages: ['string'],
                   error_messages: ['string']
                 }
               ],
               invalid_rates: [],
               rate_request_id: 'se-28529731',
               shipment_id: 'se-28529731',
               created_at: 'se-28529731',
               status: 'working',
               errors: [
                 {
                   error_source: 'carrier',
                   error_type: 'account_status',
                   error_code: 'auto_fund_not_supported',
                   message: 'Body of request cannot be nil.'
                 }
               ]
             }
           }.to_json)

    response = client.rates.get_with_shipment_details(params)
    assert_equal 'se-28529731', response[:shipment_id]
    assert_equal 'se-28529731', response[:carrier_id]
    assert_equal 'usps_first_class_mail', response[:service_code]
    assert_equal 'pending', response[:shipment_status]
    assert_equal 'John Doe', response[:ship_to][:name]
    assert_equal '1999 Bishop Grandin Blvd.', response[:ship_to][:address_line1]
    assert_equal 'Winnipeg', response[:ship_to][:city_locality]
    assert_equal 'CA', response[:ship_to][:country_code]
    assert_equal 'se-28529731', response[:warehouse_id]
    assert_equal 'none', response[:confirmation]
    assert_equal 'pickup', response[:origin_type]
    assert_equal 'amazon_ca', response[:order_source_code]
    assert_equal 1, response[:packages].length
    assert_equal 'small_flat_rate_box', response[:packages][0][:package_code]
    assert_equal 'working', response[:rate_response][:status]
    assert_equal 'se-28529731', response[:rate_response][:rate_request_id]
    assert_equal 1, response[:rate_response][:rates].length
    assert_equal 'se-28529731', response[:rate_response][:rates][0][:rate_id]
    assert_equal 'check', response[:rate_response][:rates][0][:rate_type]
    assert_equal 5, response[:rate_response][:rates][0][:delivery_days]
    assert_equal 1, response[:rate_response][:errors].length
    assert_equal 'auto_fund_not_supported', response[:rate_response][:errors][0][:error_code]
    assert_requested(stub, times: 1)
  end
end
