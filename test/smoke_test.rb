# frozen_string_literal: true

require 'test_helper'
require 'shipengine_rb'

describe 'Smoke tests' do
  it 'Should test a version number' do
    refute_nil ShipEngineRb::VERSION
  end
end
