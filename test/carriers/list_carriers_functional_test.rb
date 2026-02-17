# frozen_string_literal: true

require 'test_helper'

describe 'List Carrier Accounts: Functional' do
  after do
    WebMock.reset!
  end
  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'handles unauthorized errors' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/carriers')
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
      client.carriers.list
      assert_requested(stub, times: 1)
    end
  end

  it 'handles a successful response with multiple carriers' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/carriers')
           .to_return(status: 200, body: {
             carriers: [
               {
                 carrier_id: 'se-28529731',
                 carrier_code: 'se-28529731',
                 account_number: 'account_570827',
                 requires_funded_amount: true,
                 balance: 3799.52,
                 nickname: 'ShipEngine Account - Stamps.com',
                 friendly_name: 'Stamps.com',
                 primary: true,
                 has_multi_package_supporting_services: true,
                 supports_label_messages: true,
                 services: [
                   {
                     carrier_id: 'se-28529731',
                     carrier_code: 'se-28529731',
                     service_code: 'usps_media_mail',
                     name: 'USPS First Class Mail',
                     domestic: true,
                     international: true,
                     is_multi_package_supported: true
                   }
                 ],
                 packages: [
                   {
                     package_id: 'se-28529731',
                     package_code: 'small_flat_rate_box',
                     name: 'laptop_box',
                     dimensions: {
                       unit: 'inch',
                       length: 1,
                       width: 1,
                       height: 1
                     },
                     description: 'Packaging for laptops'
                   }
                 ],
                 options: [
                   {
                     name: 'contains_alcohol',
                     default_value: 'false',
                     description: 'string'
                   }
                 ]
               },
               {
                 carrier_id: 'se-test',
                 carrier_code: 'se-testing',
                 account_number: 'account_117',
                 requires_funded_amount: true,
                 balance: 3799.12,
                 nickname: 'ShipEngine Account 2',
                 friendly_name: 'Stamps.com 2',
                 primary: false,
                 has_multi_package_supporting_services: false,
                 supports_label_messages: false,
                 services: [
                   {
                     carrier_id: 'se-test',
                     carrier_code: 'se-test',
                     service_code: 'usps_media_mail+test',
                     name: 'USPS First Class Mail test',
                     domestic: false,
                     international: false,
                     is_multi_package_supported: false
                   }
                 ],
                 packages: [
                   {
                     package_id: 'se-28529731',
                     package_code: '+small_flat_rate_box',
                     name: 'laptop_box+test',
                     dimensions: {
                       unit: 'centimeters',
                       length: 4,
                       width: 1,
                       height: 1
                     },
                     description: 'Packaging for laptops'
                   }
                 ],
                 options: [
                   {
                     name: 'contains_alcohol',
                     default_value: 'false',
                     description: 'string'
                   }
                 ]
               }
             ],
             request_id: 'aa3d8e8e-462b-4476-9618-72db7f7b7009',
             errors: [
               {
                 error_source: 'carrier',
                 error_type: 'account_status',
                 error_code: 'auto_fund_not_supported',
                 message: 'Body of request cannot be null.'
               }
             ]
           }.to_json)

    response = client.carriers.list
    assert_equal 2, response[:carriers].length
    assert_equal 'se-28529731', response[:carriers][0][:carrier_id]
    assert_equal 'se-28529731', response[:carriers][0][:carrier_code]
    assert_equal 'account_570827', response[:carriers][0][:account_number]
    assert_equal true, response[:carriers][0][:requires_funded_amount]
    assert_equal 3799.52, response[:carriers][0][:balance]
    assert_equal 'ShipEngine Account - Stamps.com', response[:carriers][0][:nickname]
    assert_equal 'Stamps.com', response[:carriers][0][:friendly_name]
    assert_equal true, response[:carriers][0][:primary]
    assert_equal 'usps_media_mail', response[:carriers][0][:services][0][:service_code]
    assert_equal 'USPS First Class Mail', response[:carriers][0][:services][0][:name]
    assert_equal 'small_flat_rate_box', response[:carriers][0][:packages][0][:package_code]
    assert_equal 'inch', response[:carriers][0][:packages][0][:dimensions][:unit]
    assert_equal 1, response[:carriers][0][:packages][0][:dimensions][:length]
    assert_equal 'se-test', response[:carriers][1][:carrier_id]
    assert_equal 'se-testing', response[:carriers][1][:carrier_code]
    assert_equal 'aa3d8e8e-462b-4476-9618-72db7f7b7009', response[:request_id]
    assert_equal 1, response[:errors].length
    assert_equal 'carrier', response[:errors][0][:error_source]
    assert_equal 'auto_fund_not_supported', response[:errors][0][:error_code]
    assert_requested(stub, times: 1)
  end
end
