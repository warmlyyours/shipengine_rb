# frozen_string_literal: true

module ShipEngineRb
  module Exceptions
    class ErrorCode
      # @param [Symbol] key
      # @return [Symbol] error code
      def self.get(key)
        @codes[key]
      end

      # @param [String] str_key
      # @return [Symbol] error code
      def self.get_by_str(str_key)
        get(str_key.upcase.to_sym)
      end

      @codes = {
        MINIMUM_POSTAL_CODE_VERIFICATION_FAILED: 'minimum_postal_code_verification_failed',
        AUTO_FUND_NOT_SUPPORTED: 'auto_fund_not_supported',
        BATCH_CANNOT_BE_MODIFIED: 'batch_cannot_be_modified',
        CARRIER_NOT_CONNECTED: 'carrier_not_connected',
        CARRIER_NOT_SUPPORTED: 'carrier_not_supported',
        CONFIRMATION_NOT_SUPPORTED: 'confirmation_not_supported',
        FIELD_CONFLICT: 'field_conflict',
        FIELD_VALUE_REQUIRED: 'field_value_required',
        FORBIDDEN: 'forbidden',
        IDENTIFIER_CONFLICT: 'identifier_conflict',
        IDENTIFIERS_MUST_MATCH: 'identifiers_must_match',
        INCOMPATIBLE_PAIRED_LABELS: 'incompatible_paired_labels',
        INVALID_ADDRESS: 'invalid_address',
        INVALID_BILLING_PLAN: 'invalid_billing_plan',
        INVALID_CHARGE_EVENT: 'invalid_charge_event',
        INVALID_FIELD_VALUE: 'invalid_field_value',
        INVALID_IDENTIFIER: 'invalid_identifier',
        INVALID_STATUS: 'invalid_status',
        INVALID_STRING_LENGTH: 'invalid_string_length',
        LABEL_IMAGES_NOT_SUPPORTED: 'label_images_not_supported',
        METER_FAILURE: 'meter_failure',
        NOT_FOUND: 'not_found',
        RATE_LIMIT_EXCEEDED: 'rate_limit_exceeded',
        REQUEST_BODY_REQUIRED: 'request_body_required',
        RETURN_LABEL_NOT_SUPPORTED: 'return_label_not_supported',
        SUBSCRIPTION_INACTIVE: 'subscription_inactive',
        TERMS_NOT_ACCEPTED: 'terms_not_accepted',
        TIMEOUT: 'timeout',
        TRACKING_NOT_SUPPORTED: 'tracking_not_supported',
        TRIAL_EXPIRED: 'trial_expired',
        UNAUTHORIZED: 'unauthorized',
        UNSPECIFIED: 'unspecified',
        VERIFICATION_FAILURE: 'verification_failure',
        WAREHOUSE_CONFLICT: 'warehouse_conflict',
        WEBHOOK_EVENT_TYPE_CONFLICT: 'webhook_event_type_conflict',
        FUNDING_SOURCE_MISSING_CONFIGURATION: 'funding_source_missing_configuration',
        FUNDING_SOURCE_ERROR: 'funding_source_error'
      }.freeze
    end
  end
end
