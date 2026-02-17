# frozen_string_literal: true

module ShipEngineRb
  module Exceptions
    class ErrorType
      # @param [Symbol] key
      # @return [Symbol] error type
      def self.get(key)
        @types[key]
      end

      # @param [String] str_key
      # @return [Symbol] error type
      def self.get_by_str(str_key)
        get(str_key.upcase.to_sym)
      end

      @types = {
        ACCOUNT_STATUS: 'account_status',
        SECURITY: 'security',
        VALIDATION: 'validation',
        BUSINESS_RULES: 'business_rules',
        SYSTEM: 'system',
        WALLET: 'wallet',
        FUNDING_SOURCES: 'funding_sources'
      }.freeze
    end
  end
end
