# frozen_string_literal: true

module ShipEngineRb
  class Client
    attr_reader :configuration,
                :account, :addresses, :batches, :carrier_accounts, :carriers,
                :documents, :downloads, :insurance, :labels, :ltl,
                :manifests, :package_pickups, :package_types, :rates,
                :service_points, :shipments, :tags, :tokens, :tracking,
                :warehouses, :webhooks

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
