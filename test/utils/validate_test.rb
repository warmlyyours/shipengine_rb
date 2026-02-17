# frozen_string_literal: true

require 'test_helper'

describe 'Utils::Validate' do
  V = ShipEngineRb::Utils::Validate
  ValidationError = ShipEngineRb::Exceptions::ValidationError

  describe '.not_nil' do
    it 'does nothing for non-nil values' do
      V.not_nil('field', 'hello')
      V.not_nil('field', 0)
      V.not_nil('field', false)
    end

    it 'raises for nil' do
      err = assert_raises(ValidationError) { V.not_nil('my_field', nil) }
      assert_match(/my_field must be specified/, err.message)
    end
  end

  describe '.not_nil_or_empty_str' do
    it 'does nothing for non-empty strings' do
      V.not_nil_or_empty_str('f', 'hello')
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.not_nil_or_empty_str('f', nil) }
    end

    it 'raises for empty string' do
      err = assert_raises(ValidationError) { V.not_nil_or_empty_str('f', '') }
      assert_match(/f must be specified/, err.message)
    end
  end

  describe '.str' do
    it 'does nothing for strings' do
      V.str('f', 'hello')
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.str('f', nil) }
    end

    it 'raises for non-string' do
      err = assert_raises(ValidationError) { V.str('name', 123) }
      assert_match(/name must be a String/, err.message)
    end
  end

  describe '.non_empty_str' do
    it 'does nothing for non-empty strings' do
      V.non_empty_str('f', 'hello')
    end

    it 'raises for empty string' do
      err = assert_raises(ValidationError) { V.non_empty_str('name', '') }
      assert_match(/name cannot be empty/, err.message)
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.non_empty_str('f', nil) }
    end

    it 'raises for non-string' do
      assert_raises(ValidationError) { V.non_empty_str('f', 42) }
    end
  end

  describe '.non_whitespace_str' do
    it 'does nothing for strings with content' do
      V.non_whitespace_str('f', 'hello')
    end

    it 'raises for whitespace-only string' do
      err = assert_raises(ValidationError) { V.non_whitespace_str('name', '   ') }
      assert_match(/name cannot be all whitespace/, err.message)
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.non_whitespace_str('f', nil) }
    end

    it 'raises for non-string' do
      assert_raises(ValidationError) { V.non_whitespace_str('f', 42) }
    end
  end

  describe '.hash' do
    it 'does nothing for hashes' do
      V.hash('f', { key: 'value' })
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.hash('f', nil) }
    end

    it 'raises for non-hash' do
      err = assert_raises(ValidationError) { V.hash('params', 'string') }
      assert_match(/params must be Hash/, err.message)
    end
  end

  describe '.bool' do
    it 'does nothing for true' do
      V.bool('f', true)
    end

    it 'does nothing for false' do
      V.bool('f', false)
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.bool('f', nil) }
    end

    it 'raises for non-boolean' do
      err = assert_raises(ValidationError) { V.bool('flag', 'yes') }
      assert_match(/flag must be a Boolean/, err.message)
    end
  end

  describe '.number' do
    it 'does nothing for integers' do
      V.number('f', 42)
    end

    it 'does nothing for floats' do
      V.number('f', 3.14)
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.number('f', nil) }
    end

    it 'raises for non-numeric' do
      err = assert_raises(ValidationError) { V.number('count', 'ten') }
      assert_match(/count must be Numeric/, err.message)
    end
  end

  describe '.int' do
    it 'does nothing for integers' do
      V.int('f', 42)
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.int('f', nil) }
    end

    it 'raises for floats with decimal part' do
      err = assert_raises(ValidationError) { V.int('count', 3.5) }
      assert_match(/count must be a whole number/, err.message)
    end

    it 'raises for non-numeric' do
      assert_raises(ValidationError) { V.int('f', 'abc') }
    end
  end

  describe '.non_neg_int' do
    it 'does nothing for zero' do
      V.non_neg_int('f', 0)
    end

    it 'does nothing for positive integers' do
      V.non_neg_int('f', 5)
    end

    it 'raises for negative integers' do
      err = assert_raises(ValidationError) { V.non_neg_int('retries', -1) }
      assert_match(/retries must be zero or greater/, err.message)
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.non_neg_int('f', nil) }
    end
  end

  describe '.positive_int' do
    it 'does nothing for positive integers' do
      V.positive_int('f', 1)
    end

    it 'raises for zero' do
      err = assert_raises(ValidationError) { V.positive_int('page_size', 0) }
      assert_match(/page_size must be greater than zero/, err.message)
    end

    it 'raises for negative integers' do
      err = assert_raises(ValidationError) { V.positive_int('page_size', -5) }
      assert_match(/page_size must be greater than zero/, err.message)
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.positive_int('f', nil) }
    end
  end

  describe '.array' do
    it 'does nothing for arrays' do
      V.array('f', [1, 2, 3])
    end

    it 'does nothing for empty arrays' do
      V.array('f', [])
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.array('f', nil) }
    end

    it 'raises for non-array' do
      err = assert_raises(ValidationError) { V.array('items', 'not-array') }
      assert_match(/items must be an Array/, err.message)
    end
  end

  describe '.array_of_str' do
    it 'does nothing for arrays of strings' do
      V.array_of_str('f', %w[a b c])
    end

    it 'does nothing for empty arrays' do
      V.array_of_str('f', [])
    end

    it 'raises for nil' do
      assert_raises(ValidationError) { V.array_of_str('f', nil) }
    end

    it 'raises for non-array' do
      assert_raises(ValidationError) { V.array_of_str('f', 'string') }
    end

    it 'raises when array contains non-strings' do
      err = assert_raises(ValidationError) { V.array_of_str('tags', ['ok', 123]) }
      assert_match(/tags must be an Array of Strings/, err.message)
    end
  end
end
