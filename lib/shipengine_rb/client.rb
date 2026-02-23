# frozen_string_literal: true

module ShipEngineRb
  # Main client for the ShipEngine API. Uses a resource-based API pattern where
  # each domain (addresses, carriers, labels, rates, tracking, etc.) is exposed
  # as a dedicated resource object. Call methods on these resources to perform
  # API operations.
  #
  # @example Initialization and basic usage
  #   client = ShipEngineRb::Client.new("YOUR_API_KEY")
  #
  #   # With optional configuration
  #   client = ShipEngineRb::Client.new(
  #     "YOUR_API_KEY",
  #     retries: 3,
  #     timeout: 30_000,
  #     open_timeout: 5_000,
  #     page_size: 50,
  #     logger: Logger.new($stdout)
  #   )
  #
  #   # Validate addresses
  #   result = client.addresses.validate([{ name: "John", address_line1: "123 Main St", city_locality: "Austin", state_province: "TX", postal_code: "78701", country_code: "US" }])
  #
  #   # Auto-paginate labels
  #   client.labels.list_each(label_status: "completed") { |label| puts label[:label_id] }
  #
  # @see https://shipengine.github.io/shipengine-openapi/
  class Client
    attr_reader :configuration, :internal_client,
                :account, :addresses, :batches, :carrier_accounts, :carriers,
                :documents, :downloads, :insurance, :labels, :ltl,
                :manifests, :package_pickups, :package_types, :rates,
                :service_points, :shipments, :tags, :tokens, :tracking,
                :warehouses, :webhooks

    # @param api_key [String] Your ShipEngine API key (required for authentication).
    # @param retries [Integer, nil] Number of retries for failed requests (optional, default 1).
    # @param timeout [Integer, nil] Total request timeout in milliseconds (optional, default 60000).
    # @param open_timeout [Integer, nil] TCP connection timeout in milliseconds (optional, default 10000).
    # @param page_size [Integer, nil] Default page size for paginated endpoints (optional, default 50).
    # @param base_url [String, nil] Base URL for the API (optional, defaults to ShipEngine production).
    # @param logger [Logger, nil] Optional logger for request/response logging (default nil = off).
    # @param rates_timeout [Integer, nil] Timeout in milliseconds used only for rate lookups (optional).
    #   When set, the rates domain uses a dedicated connection with this timeout while all other
    #   domains use the default +timeout+. Useful for failing fast on rate estimates without
    #   affecting label generation or tracking calls.
    # @return [Client] A configured client instance with access to all domain resources.
    def initialize(api_key, retries: nil, timeout: nil, open_timeout: nil, page_size: nil, base_url: nil, logger: nil, rates_timeout: nil)
      @configuration = Configuration.new(
        api_key:,
        retries:,
        base_url:,
        timeout:,
        open_timeout:,
        page_size:,
        logger:
      )

      @internal_client = InternalClient.new(@configuration)
      ic = @internal_client
      rates_ic = rates_timeout ? InternalClient.new(@configuration.merge(timeout: rates_timeout)) : ic

      @account          = Domain::Account.new(ic)
      @addresses        = Domain::Addresses.new(ic)
      @batches          = Domain::Batches.new(ic)
      @carrier_accounts = Domain::CarrierAccounts.new(ic)
      @carriers         = Domain::Carriers.new(ic)
      @documents        = Domain::Documents.new(ic)
      @downloads        = Domain::Downloads.new(ic)
      @insurance        = Domain::Insurance.new(ic)
      @labels           = Domain::Labels.new(ic)
      @ltl              = Domain::Ltl.new(ic)
      @manifests        = Domain::Manifests.new(ic)
      @package_pickups  = Domain::PackagePickups.new(ic)
      @package_types    = Domain::PackageTypes.new(ic)
      @rates            = Domain::Rates.new(rates_ic)
      @service_points   = Domain::ServicePoints.new(ic)
      @shipments        = Domain::Shipments.new(ic)
      @tags             = Domain::Tags.new(ic)
      @tokens           = Domain::Tokens.new(ic)
      @tracking         = Domain::Tracking.new(ic)
      @warehouses       = Domain::Warehouses.new(ic)
      @webhooks         = Domain::Webhooks.new(ic)
    end
  end
end
