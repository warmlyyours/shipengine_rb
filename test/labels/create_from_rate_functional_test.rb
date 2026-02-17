# frozen_string_literal: true

require 'test_helper'

describe 'Create Label from Rate: Functional' do
  after do
    WebMock.reset!
  end
  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'handles unauthorized errors' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/labels/rates/se-324658')
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
      client.labels.create_from_rate('se-324658', {})
      assert_requested(stub, times: 1)
    end
  end

  it 'handles a successful response for track_using_label_id' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/labels/rates/se-324658')
           .to_return(status: 200, body: {
             label_id: 'se-28529731',
             status: 'processing',
             shipment_id: 'se-28529731',
             ship_date: '2018-09-23T00:00:00.000Z',
             created_at: '2018-09-23T15:00:00.000Z',
             shipment_cost: {
               currency: 'usd',
               amount: 0
             },
             insurance_cost: {
               currency: 'usd',
               amount: 0
             },
             tracking_number: '782758401696',
             is_return_label: true,
             rma_number: 'string',
             is_international: true,
             batch_id: 'se-28529731',
             carrier_id: 'se-28529731',
             charge_event: 'carrier_default',
             service_code: 'usps_first_class_mail',
             package_code: 'small_flat_rate_box',
             voided: true,
             voided_at: '2018-09-23T15:00:00.000Z',
             label_format: 'pdf',
             display_scheme: 'label',
             label_layout: '4x6',
             trackable: true,
             label_image_id: 'img_DtBXupDBxREpHnwEXhTfgK',
             carrier_code: 'dhl_express',
             tracking_status: 'unknown',
             label_download: {
               href: 'http://api.shipengine.com/v1/labels/se-28529731',
               pdf: 'http://api.shipengine.com/v1/labels/se-28529731',
               png: 'http://api.shipengine.com/v1/labels/se-28529731',
               zpl: 'http://api.shipengine.com/v1/labels/se-28529731'
             },
             form_download: {
               href: 'http://api.shipengine.com/v1/labels/se-28529731',
               type: 'string'
             },
             insurance_claim: {
               href: 'http://api.shipengine.com/v1/labels/se-28529731',
               type: 'string'
             },
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
             ]
           }.to_json)

    response = client.labels.create_from_rate('se-324658', {})
    assert_equal 'se-28529731', response[:label_id]
    assert_equal 'processing', response[:status]
    assert_equal 'se-28529731', response[:shipment_id]
    assert_equal '782758401696', response[:tracking_number]
    assert_equal true, response[:is_return_label]
    assert_equal 'usps_first_class_mail', response[:service_code]
    assert_equal 'small_flat_rate_box', response[:package_code]
    assert_equal 'pdf', response[:label_format]
    assert_equal 'http://api.shipengine.com/v1/labels/se-28529731', response[:label_download][:href]
    assert_equal 1, response[:packages].length
    assert_equal 'small_flat_rate_box', response[:packages][0][:package_code]
    assert_equal 0, response[:packages][0][:weight][:value]
    assert_equal 'pound', response[:packages][0][:weight][:unit]
    assert_requested(stub, times: 1)
  end
end
