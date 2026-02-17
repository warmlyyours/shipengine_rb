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
  #     timeout: 30,
  #     page_size: 50,
  #     base_url: "https://api.shipengine.com"
  #   )
  #
  #   # Validate addresses
  #   result = client.addresses.validate([{ name: "John", address_line1: "123 Main St", city: "Austin", state: "TX", postal_code: "78701", country_code: "US" }])
  #
  #   # Get shipping rates
  #   rates = client.rates.get_with_shipment_details(shipment_details)
  #
  #   # Create a label
  #   label = client.labels.create_from_rate(rate_id)
  #
  # @see https://shipengine.github.io/shipengine-openapi/
  class Client
    attr_reader :configuration,
                :account, :addresses, :batches, :carrier_accounts, :carriers,
                :documents, :downloads, :insurance, :labels, :ltl,
                :manifests, :package_pickups, :package_types, :rates,
                :service_points, :shipments, :tags, :tokens, :tracking,
                :warehouses, :webhooks

    # @param api_key [String] Your ShipEngine API key (required for authentication).
    # @param retries [Integer, nil] Number of retries for failed requests (optional).
    # @param timeout [Integer, nil] Request timeout in seconds (optional).
    # @param page_size [Integer, nil] Default page size for paginated endpoints (optional).
    # @param base_url [String, nil] Base URL for the API (optional, defaults to ShipEngine production).
    # @return [Client] A configured client instance with access to all domain resources.
    def initialize(api_key, retries: nil, timeout: nil, page_size: nil, base_url: nil)
      @configuration = Configuration.new(
        api_key:,
        retries:,
        base_url:,
        timeout:,
        page_size:
      )

      ic = InternalClient.new(@configuration)

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
      @rates            = Domain::Rates.new(ic)
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
