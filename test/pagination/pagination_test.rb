# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Pagination' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  describe 'list_all (lazy enumerator)' do
    it 'fetches all items across multiple pages' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels?page=1')
        .to_return(status: 200, body: {
          labels: [{ label_id: 'se-label-1' }, { label_id: 'se-label-2' }],
          total: 5, page: 1, pages: 3
        }.to_json)

      stub_request(:get, 'https://api.shipengine.com/v1/labels?page=2')
        .to_return(status: 200, body: {
          labels: [{ label_id: 'se-label-3' }, { label_id: 'se-label-4' }],
          total: 5, page: 2, pages: 3
        }.to_json)

      stub_request(:get, 'https://api.shipengine.com/v1/labels?page=3')
        .to_return(status: 200, body: {
          labels: [{ label_id: 'se-label-5' }],
          total: 5, page: 3, pages: 3
        }.to_json)

      all_labels = client.labels.list_all.to_a
      assert_equal 5, all_labels.length
      assert_equal 'se-label-1', all_labels[0][:label_id]
      assert_equal 'se-label-5', all_labels[4][:label_id]
    end

    it 'returns empty for no results' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels?page=1')
        .to_return(status: 200, body: {
          labels: [], total: 0, page: 1, pages: 0
        }.to_json)

      all_labels = client.labels.list_all.to_a
      assert_empty all_labels
    end

    it 'stops when items are empty' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels?page=1')
        .to_return(status: 200, body: {
          labels: [{ label_id: 'se-label-1' }],
          total: 1, page: 1, pages: 2
        }.to_json)

      stub_request(:get, 'https://api.shipengine.com/v1/labels?page=2')
        .to_return(status: 200, body: {
          labels: [], total: 1, page: 2, pages: 2
        }.to_json)

      all_labels = client.labels.list_all.to_a
      assert_equal 1, all_labels.length
    end

    it 'is lazy — only fetches pages as needed' do
      page1 = stub_request(:get, 'https://api.shipengine.com/v1/labels?page=1')
              .to_return(status: 200, body: {
                labels: [{ label_id: 'se-label-1' }, { label_id: 'se-label-2' }],
                total: 4, page: 1, pages: 2
              }.to_json)

      page2 = stub_request(:get, 'https://api.shipengine.com/v1/labels?page=2')
              .to_return(status: 200, body: {
                labels: [{ label_id: 'se-label-3' }, { label_id: 'se-label-4' }],
                total: 4, page: 2, pages: 2
              }.to_json)

      first_label = client.labels.list_all.first
      assert_equal 'se-label-1', first_label[:label_id]
      assert_requested(page1, times: 1)
      assert_not_requested(page2)
    end

    it 'handles single-page results' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels?page=1')
        .to_return(status: 200, body: {
          labels: [{ label_id: 'se-label-1' }],
          total: 1, page: 1, pages: 1
        }.to_json)

      all_labels = client.labels.list_all.to_a
      assert_equal 1, all_labels.length
    end

    it 'handles missing pages key (defaults to 1)' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels?page=1')
        .to_return(status: 200, body: {
          labels: [{ label_id: 'se-label-1' }],
          total: 1, page: 1
        }.to_json)

      all_labels = client.labels.list_all.to_a
      assert_equal 1, all_labels.length
    end
  end

  describe 'list_each (block-based)' do
    it 'yields each item across pages' do
      stub_request(:get, 'https://api.shipengine.com/v1/batches?page=1')
        .to_return(status: 200, body: {
          batches: [{ batch_id: 'se-batch-1' }, { batch_id: 'se-batch-2' }],
          total: 3, page: 1, pages: 2
        }.to_json)

      stub_request(:get, 'https://api.shipengine.com/v1/batches?page=2')
        .to_return(status: 200, body: {
          batches: [{ batch_id: 'se-batch-3' }],
          total: 3, page: 2, pages: 2
        }.to_json)

      collected = []
      client.batches.list_each { |batch| collected << batch[:batch_id] }
      assert_equal %w[se-batch-1 se-batch-2 se-batch-3], collected
    end
  end

  describe 'works with shipments' do
    it 'paginates shipments' do
      stub_request(:get, 'https://api.shipengine.com/v1/shipments?page=1')
        .to_return(status: 200, body: {
          shipments: [{ shipment_id: 'se-ship-1' }],
          total: 1, page: 1, pages: 1
        }.to_json)

      all_shipments = client.shipments.list_all.to_a
      assert_equal 1, all_shipments.length
      assert_equal 'se-ship-1', all_shipments[0][:shipment_id]
    end
  end

  describe 'works with manifests' do
    it 'paginates manifests' do
      stub_request(:get, 'https://api.shipengine.com/v1/manifests?page=1')
        .to_return(status: 200, body: {
          manifests: [{ manifest_id: 'se-man-1' }],
          total: 1, page: 1, pages: 1
        }.to_json)

      all_manifests = client.manifests.list_all.to_a
      assert_equal 1, all_manifests.length
    end
  end

  describe 'works with package_pickups' do
    it 'paginates package pickups' do
      stub_request(:get, 'https://api.shipengine.com/v1/pickups?page=1')
        .to_return(status: 200, body: {
          pickups: [{ pickup_id: 'pik-1' }],
          total: 1, page: 1, pages: 1
        }.to_json)

      all_pickups = client.package_pickups.list_all.to_a
      assert_equal 1, all_pickups.length
    end
  end
end
