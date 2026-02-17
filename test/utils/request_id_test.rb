# frozen_string_literal: true

require 'test_helper'

describe 'Utils::RequestId' do
  it 'creates IDs with the req_ prefix' do
    id = ShipEngineRb::Utils::RequestId.create
    assert id.start_with?('req_'), "Expected ID to start with 'req_', got: #{id}"
  end

  it 'creates unique IDs' do
    ids = 10.times.map { ShipEngineRb::Utils::RequestId.create }
    assert_equal 10, ids.uniq.size, 'Expected 10 unique IDs'
  end

  it 'matches the request ID format' do
    id = ShipEngineRb::Utils::RequestId.create
    assert_match(/^req_\w+$/, id)
  end
end
