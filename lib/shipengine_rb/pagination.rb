# frozen_string_literal: true

module ShipEngineRb
  # Mixin for domain classes that support paginated list endpoints.
  # Provides `paginate_each` and `paginate_all` helpers that automatically
  # fetch successive pages from the API.
  #
  # @example In a domain class
  #   class Labels
  #     include ShipEngineRb::Pagination
  #
  #     def list(params = {}, config: {})
  #       @internal_client.get('/v1/labels', params, config)
  #     end
  #
  #     def list_all(params = {}, config: {})
  #       paginate_all(:list, :labels, params, config:)
  #     end
  #
  #     def list_each(params = {}, config: {}, &block)
  #       paginate_each(:list, :labels, params, config:, &block)
  #     end
  #   end
  module Pagination
    # Returns a lazy Enumerator that yields every item across all pages.
    #
    # @param method_name [Symbol] The list method to call (e.g. :list).
    # @param collection_key [Symbol] The key in the response containing items (e.g. :labels).
    # @param params [Hash] Query params passed to the list method.
    # @param config [Hash] Per-request configuration overrides.
    # @return [Enumerator::Lazy] Lazy enumerator of all items across pages.
    def paginate_all(method_name, collection_key, params = {}, config: {})
      Enumerator.new do |yielder|
        page = params.fetch(:page, 1)
        loop do
          result = send(method_name, params.merge(page: page), config:)
          items = result[collection_key] || []
          items.each { |item| yielder << item }

          total_pages = result[:pages] || 1
          break if page >= total_pages || items.empty?

          page += 1
        end
      end.lazy
    end

    # Iterates over every item across all pages, yielding to the block.
    #
    # @param method_name [Symbol] The list method to call.
    # @param collection_key [Symbol] The key containing the items array.
    # @param params [Hash] Query params.
    # @param config [Hash] Per-request config.
    # @yield [Hash] Each item from the paginated results.
    def paginate_each(method_name, collection_key, params = {}, config: {}, &)
      paginate_all(method_name, collection_key, params, config:).each(&)
    end
  end
end
