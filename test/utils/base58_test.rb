# frozen_string_literal: true

require 'test_helper'

describe 'Base58' do
  describe '.int_to_base58' do
    it 'encodes 0' do
      assert_equal '1', Base58.int_to_base58(0)
    end

    it 'encodes small integers' do
      assert_equal '2', Base58.int_to_base58(1)
    end

    it 'encodes larger integers' do
      result = Base58.int_to_base58(12_345)
      assert_instance_of String, result
      refute_empty result
    end

    it 'round-trips with base58_to_int' do
      [0, 1, 57, 58, 1000, 999_999].each do |n|
        encoded = Base58.int_to_base58(n)
        decoded = Base58.base58_to_int(encoded)
        assert_equal n, decoded, "Round-trip failed for #{n}"
      end
    end

    it 'raises for non-integer' do
      assert_raises(ArgumentError) { Base58.int_to_base58('hello') }
    end

    it 'raises for invalid alphabet' do
      assert_raises(ArgumentError) { Base58.int_to_base58(42, :invalid) }
    end

    it 'supports bitcoin alphabet' do
      result = Base58.int_to_base58(12_345, :bitcoin)
      assert_instance_of String, result
      refute_empty result
    end
  end

  describe '.base58_to_int' do
    it 'decodes "1" to 0' do
      assert_equal 0, Base58.base58_to_int('1')
    end

    it 'decodes "2" to 1' do
      assert_equal 1, Base58.base58_to_int('2')
    end

    it 'raises for invalid character' do
      assert_raises(ArgumentError) { Base58.base58_to_int('0') }
    end

    it 'raises for invalid alphabet' do
      assert_raises(ArgumentError) { Base58.base58_to_int('abc', :invalid) }
    end
  end

  describe '.binary_to_base58' do
    it 'encodes binary data' do
      binary = "\x00\x01\x02".dup.force_encoding('BINARY')
      result = Base58.binary_to_base58(binary)
      assert_instance_of String, result
      refute_empty result
    end

    it 'handles empty binary' do
      result = Base58.binary_to_base58(''.dup.force_encoding('BINARY'))
      assert_equal '1', result
    end

    it 'handles leading zeroes' do
      binary = "\x00\x00\x01".dup.force_encoding('BINARY')
      result = Base58.binary_to_base58(binary)
      assert result.start_with?('11'), "Expected leading '11' for two zero bytes, got: #{result}"
    end

    it 'can exclude leading zeroes' do
      binary = "\x00\x00\x01".dup.force_encoding('BINARY')
      result = Base58.binary_to_base58(binary, :flickr, false)
      refute result.start_with?('11')
    end

    it 'raises for non-string' do
      assert_raises(ArgumentError) { Base58.binary_to_base58(12_345) }
    end

    it 'raises for non-binary encoding' do
      assert_raises(ArgumentError) { Base58.binary_to_base58('hello') }
    end

    it 'raises for invalid alphabet' do
      binary = "\x01".dup.force_encoding('BINARY')
      assert_raises(ArgumentError) { Base58.binary_to_base58(binary, :invalid) }
    end
  end

  describe '.base58_to_binary' do
    it 'round-trips with binary_to_base58' do
      binary = "\x00\x01\xFF".dup.force_encoding('BINARY')
      encoded = Base58.binary_to_base58(binary)
      decoded = Base58.base58_to_binary(encoded)
      assert_equal binary, decoded
    end

    it 'raises for invalid alphabet' do
      assert_raises(ArgumentError) { Base58.base58_to_binary('abc', :invalid) }
    end
  end

  describe 'aliases' do
    it '.encode is an alias for .int_to_base58' do
      assert_equal Base58.int_to_base58(42), Base58.encode(42)
    end

    it '.decode is an alias for .base58_to_int' do
      assert_equal Base58.base58_to_int('2'), Base58.decode('2')
    end
  end

  describe 'Private.int_to_hex' do
    it 'converts integers to even-length hex strings' do
      assert_equal '00', Base58::Private.int_to_hex(0)
      assert_equal '01', Base58::Private.int_to_hex(1)
      assert_equal '0f', Base58::Private.int_to_hex(15)
      assert_equal '10', Base58::Private.int_to_hex(16)
      assert_equal 'ff', Base58::Private.int_to_hex(255)
    end
  end
end
