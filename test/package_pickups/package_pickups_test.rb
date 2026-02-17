# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'PackagePickups' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists pickups' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/pickups')
           .to_return(status: 200, body: {
             pickups: [{ pickup_id: 'pik-1', status: 'scheduled' }],
             total: 1, page: 1, pages: 1
           }.to_json)

    response = client.package_pickups.list
    assert_equal 1, response[:total]
    assert_equal 'pik-1', response[:pickups][0][:pickup_id]
    assert_requested(stub, times: 1)
  end

  it 'schedules a pickup' do
    params = {
      carrier_id: 'se-carrier-1',
      label_ids: ['se-label-1'],
      pickup_window: { start_at: '2026-03-01T08:00:00Z', end_at: '2026-03-01T17:00:00Z' }
    }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/pickups')
           .with(body: params.to_json)
           .to_return(status: 200, body: {
             pickup_id: 'pik-2',
             status: 'scheduled',
             carrier_id: 'se-carrier-1'
           }.to_json)

    response = client.package_pickups.schedule(params)
    assert_equal 'pik-2', response[:pickup_id]
    assert_equal 'scheduled', response[:status]
    assert_requested(stub, times: 1)
  end

  it 'gets a pickup by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/pickups/pik-1')
           .to_return(status: 200, body: {
             pickup_id: 'pik-1',
             status: 'scheduled',
             carrier_id: 'se-carrier-1'
           }.to_json)

    response = client.package_pickups.get_by_id('pik-1')
    assert_equal 'pik-1', response[:pickup_id]
    assert_requested(stub, times: 1)
  end

  it 'deletes a pickup' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/pickups/pik-1')
           .to_return(status: 204, body: {}.to_json)

    client.package_pickups.delete('pik-1')
    assert_requested(stub, times: 1)
  end
end
