# frozen_string_literal: true

require 'test_helper'

describe 'Track using carrier code and tracking number: Functional' do
  after do
    WebMock.reset!
  end
  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'handles unauthorized errors' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/tracking?carrier_code=1&tracking_number=1')
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
      client.tracking.track('1', '1')
      assert_requested(stub, times: 1)
    end
  end

  it 'handles a successful response for track_using_label_id' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/tracking?carrier_code=1&tracking_number=1')
           .to_return(status: 200, body: {
             tracking_number: '1Z932R800390810600',
             status_code: 'DE',
             status_description: 'Delivered',
             carrier_status_code: 'D',
             carrier_status_description: 'DELIVERED',
             shipped_date: '2019-07-27T11:59:03.289Z',
             estimated_delivery_date: '2019-07-27T11:59:03.289Z',
             actual_delivery_date: '2019-07-27T11:59:03.289Z',
             exception_description: nil,
             events: [
               {
                 occurred_at: '2019-09-13T12:32:00Z',
                 carrier_occurred_at: '2019-09-13T05:32:00',
                 description: 'Arrived at USPS Facility',
                 city_locality: 'OCEANSIDE',
                 state_province: 'CA',
                 postal_code: '92056',
                 country_code: '',
                 company_name: '',
                 signer: '',
                 event_code: 'U1',
                 latitude: -90,
                 longitude: -180
               }
             ]
           }.to_json)

    response = client.tracking.track('1', '1')
    assert_equal '1Z932R800390810600', response['tracking_number']
    assert_equal 'DE', response['status_code']
    assert_equal 'Delivered', response['status_description']
    assert_equal 'D', response['carrier_status_code']
    assert_equal 'DELIVERED', response['carrier_status_description']
    assert_equal 1, response['events'].length
    assert_equal 'Arrived at USPS Facility', response['events'][0]['description']
    assert_equal 'OCEANSIDE', response['events'][0]['city_locality']
    assert_equal 'CA', response['events'][0]['state_province']
    assert_equal '92056', response['events'][0]['postal_code']
    assert_equal 'U1', response['events'][0]['event_code']
    assert_requested(stub, times: 1)
  end
end
