# frozen_string_literal: true

require_relative 'lib/shipengine_rb/version'

Gem::Specification.new do |spec|
  spec.name          = 'shipengine_rb'
  spec.version       = ShipEngineRb::VERSION
  spec.authors       = ['WarmlyYours']
  spec.summary       = 'A comprehensive Ruby SDK for the ShipEngine API, including LTL freight support.'
  spec.description   = 'Full-coverage Ruby client for the ShipEngine shipping API. ' \
                       'Covers parcel labels, rates, tracking, shipments, carriers, batches, ' \
                       'warehouses, webhooks, and LTL freight (quotes, pickups, tracking). ' \
                       'Built on Faraday 2.x with automatic retries and rate-limit handling.'
  spec.homepage      = 'https://github.com/warmlyyours/shipengine_rb'
  spec.license       = 'MIT'
  spec.files = Dir['*.{md,txt}', '{lib}/**/*']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.4'

  spec.add_dependency('faraday', '~> 2.0')
  spec.add_dependency('faraday-retry', '~> 2.0')
  spec.metadata['rubygems_mfa_required'] = 'true'
end
