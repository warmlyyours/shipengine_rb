# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Documents' do
  after do
    WebMock.reset!
  end

  client = ShipEngine::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'creates a combined label document' do
    params = { label_ids: ['se-label-1', 'se-label-2'] }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/documents/combined_labels')
           .with(body: params.to_json)
           .to_return(status: 200, body: {
             form_id: 'frm-1',
             label_layout: '4x6',
             pdf_url: 'https://api.shipengine.com/v1/downloads/...'
           }.to_json)

    response = client.create_combined_label_document(params)
    assert_equal 'frm-1', response['form_id']
    assert_equal '4x6', response['label_layout']
    assert_requested(stub, times: 1)
  end
end
