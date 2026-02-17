# frozen_string_literal: true

module ShipEngineRb
  module Utils
    class UserAgent
      attr_reader :version, :platform

      def initialize(version = VERSION, platform = RUBY_PLATFORM)
        raise ::StandardError, 'Cannot get version' unless version
        raise ::StandardError, 'Cannot get platform' unless platform

        @version = version
        @platform = platform
      end

      def to_s
        "shipengine_rb/#{@version} (#{@platform})"
      end
    end
  end
end
