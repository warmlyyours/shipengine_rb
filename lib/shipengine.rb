# frozen_string_literal: true

require 'shipengine/internal_client'
require 'shipengine/domain'
require 'shipengine/configuration'
require 'shipengine/utils/validate'
require 'shipengine/version'
require 'shipengine/constants'

module ShipEngine
  class Client
    attr_accessor :configuration

    def initialize(api_key, retries: nil, timeout: nil, page_size: nil, base_url: nil)
      @configuration = Configuration.new(
        api_key:,
        retries:,
        base_url:,
        timeout:,
        page_size:
      )

      @internal_client = ShipEngine::InternalClient.new(@configuration)
      @account = Domain::Account.new(@internal_client)
      @addresses = Domain::Addresses.new(@internal_client)
      @batches = Domain::Batches.new(@internal_client)
      @carrier_accounts = Domain::CarrierAccounts.new(@internal_client)
      @carriers = Domain::Carriers.new(@internal_client)
      @documents = Domain::Documents.new(@internal_client)
      @downloads = Domain::Downloads.new(@internal_client)
      @insurance = Domain::Insurance.new(@internal_client)
      @labels = Domain::Labels.new(@internal_client)
      @manifests = Domain::Manifests.new(@internal_client)
      @package_pickups = Domain::PackagePickups.new(@internal_client)
      @package_types = Domain::PackageTypes.new(@internal_client)
      @rates = Domain::Rates.new(@internal_client)
      @service_points = Domain::ServicePoints.new(@internal_client)
      @shipments = Domain::Shipments.new(@internal_client)
      @tags = Domain::Tags.new(@internal_client)
      @tokens = Domain::Tokens.new(@internal_client)
      @tracking = Domain::Tracking.new(@internal_client)
      @warehouses = Domain::Warehouses.new(@internal_client)
      @webhooks = Domain::Webhooks.new(@internal_client)
    end

    # ── Addresses ──────────────────────────────────────────────────────

    # Validate an array of addresses
    # @param addresses [Array<Hash>]
    # @param config [Hash?]
    # @return [Array<ShipEngine::Domain::Addresses::AddressValidation::Response>]
    # @see https://shipengine.github.io/shipengine-openapi/#operation/validate_address
    def validate_addresses(address, config = {})
      @addresses.validate(address, config)
    end

    # Parse an address from unstructured text
    # @param text [Hash] - { text: "string" }
    # @param config [Hash?]
    # @return [Hash]
    def parse_address(text, config = {})
      @addresses.parse(text, config)
    end

    # ── Carriers ───────────────────────────────────────────────────────

    # List all carriers
    # @param config [Hash?]
    # @return [ShipEngine::Domain::Carriers::ListCarriers::Response]
    def list_carriers(config: {})
      @carriers.list_carriers(config:)
    end

    # Get carrier by ID
    # @param carrier_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_carrier_by_id(carrier_id, config: {})
      @carriers.get_by_id(carrier_id, config:)
    end

    # Disconnect a carrier
    # @param carrier_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def disconnect_carrier(carrier_id, config: {})
      @carriers.disconnect(carrier_id, config:)
    end

    # Add funds to a carrier
    # @param carrier_id [String]
    # @param amount [Hash] - { currency:, amount: }
    # @param config [Hash?]
    # @return [Hash]
    def add_funds_to_carrier(carrier_id, amount, config: {})
      @carriers.add_funds(carrier_id, amount, config:)
    end

    # List carrier services
    # @param carrier_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def list_carrier_services(carrier_id, config: {})
      @carriers.list_services(carrier_id, config:)
    end

    # List carrier packages
    # @param carrier_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def list_carrier_packages(carrier_id, config: {})
      @carriers.list_packages(carrier_id, config:)
    end

    # List carrier options
    # @param carrier_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def list_carrier_options(carrier_id, config: {})
      @carriers.list_options(carrier_id, config:)
    end

    # ── Labels ─────────────────────────────────────────────────────────

    # Create label from Rate ID
    # @param rate_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [ShipEngine::Domain::Labels::CreateFromRate::Response]
    def create_label_from_rate(rate_id, params, config = {})
      @labels.create_from_rate(rate_id, params, config)
    end

    # Create label from shipment details
    # @param params [Hash]
    # @param config [Hash?]
    # @return [ShipEngine::Domain::Labels::CreateFromShipmentDetails::Response]
    def create_label_from_shipment_details(params, config = {})
      @labels.create_from_shipment_details(params, config)
    end

    # Void a label
    # @param label_id [String]
    # @param config [Hash?]
    # @return [ShipEngine::Domain::Labels::VoidLabel::Response]
    def void_label_with_label_id(label_id, config = {})
      @labels.void(label_id, config)
    end

    # List labels
    # @param params [Hash] - query params
    # @param config [Hash?]
    # @return [Hash]
    def list_labels(params = {}, config = {})
      @labels.list(params, config)
    end

    # Get label by ID
    # @param label_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_label_by_id(label_id, config = {})
      @labels.get_by_id(label_id, config)
    end

    # Get label by external shipment ID
    # @param external_shipment_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_label_by_external_shipment_id(external_shipment_id, config = {})
      @labels.get_by_external_shipment_id(external_shipment_id, config)
    end

    # Create a return label
    # @param label_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_return_label(label_id, params = {}, config = {})
      @labels.create_return_label(label_id, params, config)
    end

    # Create a label from an existing shipment ID
    # @param shipment_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_label_from_shipment_id(shipment_id, params = {}, config = {})
      @labels.create_from_shipment_id(shipment_id, params, config)
    end

    # ── Rates ──────────────────────────────────────────────────────────

    # Get rates with shipment details
    # @param shipment_details [Hash]
    # @param config [Hash?]
    # @return [ShipEngine::Domain::Rates::GetWithShipmentDetails::Response]
    def get_rates_with_shipment_details(shipment_details, config = {})
      @rates.get_rates_with_shipment_details(shipment_details, config)
    end

    # Estimate rates
    # @param shipment_details [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def estimate_rates(shipment_details, config = {})
      @rates.estimate(shipment_details, config)
    end

    # Get rate by ID
    # @param rate_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_rate_by_id(rate_id, config = {})
      @rates.get_by_id(rate_id, config)
    end

    # Get bulk rates
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def get_bulk_rates(params, config = {})
      @rates.bulk(params, config)
    end

    # ── Tracking ───────────────────────────────────────────────────────

    # Track by label ID
    # @param label_id [String]
    # @param config [Hash?]
    # @return [ShipEngine::Domain::Tracking::TrackUsingLabelId::Response]
    def track_using_label_id(label_id, config = {})
      @tracking.track_using_label_id(label_id, config)
    end

    # Track by carrier code and tracking number
    # @param carrier_code [String]
    # @param tracking_number [String]
    # @param config [Hash?]
    # @return [ShipEngine::Domain::Tracking::TrackUsingCarrierCodeAndTrackingNumber::Response]
    def track_using_carrier_code_and_tracking_number(carrier_code, tracking_number, config = {})
      @tracking.track_using_carrier_code_and_tracking_number(carrier_code, tracking_number, config)
    end

    # Start tracking a package
    # @param carrier_code [String]
    # @param tracking_number [String]
    # @param config [Hash?]
    # @return [Hash]
    def start_tracking(carrier_code, tracking_number, config = {})
      @tracking.start_tracking(carrier_code, tracking_number, config)
    end

    # Stop tracking a package
    # @param carrier_code [String]
    # @param tracking_number [String]
    # @param config [Hash?]
    # @return [Hash]
    def stop_tracking(carrier_code, tracking_number, config = {})
      @tracking.stop_tracking(carrier_code, tracking_number, config)
    end

    # ── Shipments ──────────────────────────────────────────────────────

    # List shipments
    # @param params [Hash] - query params
    # @param config [Hash?]
    # @return [Hash]
    def list_shipments(params = {}, config: {})
      @shipments.list(params, config:)
    end

    # Create shipments
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_shipments(params, config: {})
      @shipments.create(params, config:)
    end

    # Get shipment by ID
    # @param shipment_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_shipment_by_id(shipment_id, config: {})
      @shipments.get_by_id(shipment_id, config:)
    end

    # Update a shipment
    # @param shipment_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_shipment(shipment_id, params, config: {})
      @shipments.update(shipment_id, params, config:)
    end

    # Cancel a shipment
    # @param shipment_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def cancel_shipment(shipment_id, config: {})
      @shipments.cancel(shipment_id, config:)
    end

    # Tag a shipment
    # @param shipment_id [String]
    # @param tag_name [String]
    # @param config [Hash?]
    # @return [Hash]
    def tag_shipment(shipment_id, tag_name, config: {})
      @shipments.add_tag(shipment_id, tag_name, config:)
    end

    # Untag a shipment
    # @param shipment_id [String]
    # @param tag_name [String]
    # @param config [Hash?]
    # @return [Hash]
    def untag_shipment(shipment_id, tag_name, config: {})
      @shipments.remove_tag(shipment_id, tag_name, config:)
    end

    # Get shipment by external ID
    # @param external_shipment_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_shipment_by_external_id(external_shipment_id, config: {})
      @shipments.get_by_external_id(external_shipment_id, config:)
    end

    # Parse shipping info from unstructured text
    # @param params [Hash] - { text: "...", shipment: { ... } }
    # @param config [Hash?]
    # @return [Hash]
    def parse_shipment(params, config: {})
      @shipments.parse(params, config:)
    end

    # Get rates for a shipment
    # @param shipment_id [String]
    # @param params [Hash] - query params
    # @param config [Hash?]
    # @return [Hash]
    def get_shipment_rates(shipment_id, params = {}, config: {})
      @shipments.get_rates(shipment_id, params, config:)
    end

    # List tags for a shipment
    # @param shipment_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def list_shipment_tags(shipment_id, config: {})
      @shipments.list_tags(shipment_id, config:)
    end

    # Bulk update shipment tags
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_shipment_tags(params, config: {})
      @shipments.update_tags(params, config:)
    end

    # ── Batches ────────────────────────────────────────────────────────

    # List batches
    # @param params [Hash] - query params
    # @param config [Hash?]
    # @return [Hash]
    def list_batches(params = {}, config: {})
      @batches.list(params, config:)
    end

    # Create a batch
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_batch(params, config: {})
      @batches.create(params, config:)
    end

    # Get batch by ID
    # @param batch_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_batch_by_id(batch_id, config: {})
      @batches.get_by_id(batch_id, config:)
    end

    # Delete a batch
    # @param batch_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def delete_batch(batch_id, config: {})
      @batches.delete(batch_id, config:)
    end

    # Process a batch
    # @param batch_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def process_batch(batch_id, params = {}, config: {})
      @batches.process(batch_id, params, config:)
    end

    # Get batch by external ID
    # @param external_batch_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_batch_by_external_id(external_batch_id, config: {})
      @batches.get_by_external_id(external_batch_id, config:)
    end

    # Add shipments to a batch
    # @param batch_id [String]
    # @param params [Hash] - { shipment_ids: [...] }
    # @param config [Hash?]
    # @return [Hash]
    def add_shipments_to_batch(batch_id, params, config: {})
      @batches.add_shipments(batch_id, params, config:)
    end

    # Remove shipments from a batch
    # @param batch_id [String]
    # @param params [Hash] - { shipment_ids: [...] }
    # @param config [Hash?]
    # @return [Hash]
    def remove_shipments_from_batch(batch_id, params, config: {})
      @batches.remove_shipments(batch_id, params, config:)
    end

    # Get batch errors
    # @param batch_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_batch_errors(batch_id, config: {})
      @batches.get_errors(batch_id, config:)
    end

    # ── Webhooks ───────────────────────────────────────────────────────

    # List webhooks
    # @param config [Hash?]
    # @return [Hash]
    def list_webhooks(config: {})
      @webhooks.list(config:)
    end

    # Create a webhook
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_webhook(params, config: {})
      @webhooks.create(params, config:)
    end

    # Get webhook by ID
    # @param webhook_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_webhook_by_id(webhook_id, config: {})
      @webhooks.get_by_id(webhook_id, config:)
    end

    # Update a webhook
    # @param webhook_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_webhook(webhook_id, params, config: {})
      @webhooks.update(webhook_id, params, config:)
    end

    # Delete a webhook
    # @param webhook_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def delete_webhook(webhook_id, config: {})
      @webhooks.delete(webhook_id, config:)
    end

    # ── Warehouses ─────────────────────────────────────────────────────

    # List warehouses
    # @param config [Hash?]
    # @return [Hash]
    def list_warehouses(config: {})
      @warehouses.list(config:)
    end

    # Create a warehouse
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_warehouse(params, config: {})
      @warehouses.create(params, config:)
    end

    # Get warehouse by ID
    # @param warehouse_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_warehouse_by_id(warehouse_id, config: {})
      @warehouses.get_by_id(warehouse_id, config:)
    end

    # Update a warehouse
    # @param warehouse_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_warehouse(warehouse_id, params, config: {})
      @warehouses.update(warehouse_id, params, config:)
    end

    # Delete a warehouse
    # @param warehouse_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def delete_warehouse(warehouse_id, config: {})
      @warehouses.delete(warehouse_id, config:)
    end

    # Update warehouse settings
    # @param warehouse_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_warehouse_settings(warehouse_id, params, config: {})
      @warehouses.update_settings(warehouse_id, params, config:)
    end

    # ── Tags ───────────────────────────────────────────────────────────

    # List tags
    # @param config [Hash?]
    # @return [Hash]
    def list_tags(config: {})
      @tags.list(config:)
    end

    # Create a tag
    # @param tag_name [String]
    # @param config [Hash?]
    # @return [Hash]
    def create_tag(tag_name, config: {})
      @tags.create(tag_name, config:)
    end

    # Delete a tag
    # @param tag_name [String]
    # @param config [Hash?]
    # @return [Hash]
    def delete_tag(tag_name, config: {})
      @tags.delete(tag_name, config:)
    end

    # Rename a tag
    # @param tag_name [String]
    # @param new_tag_name [String]
    # @param config [Hash?]
    # @return [Hash]
    def rename_tag(tag_name, new_tag_name, config: {})
      @tags.rename(tag_name, new_tag_name, config:)
    end

    # ── Manifests ──────────────────────────────────────────────────────

    # List manifests
    # @param params [Hash] - query params
    # @param config [Hash?]
    # @return [Hash]
    def list_manifests(params = {}, config: {})
      @manifests.list(params, config:)
    end

    # Create a manifest
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_manifest(params, config: {})
      @manifests.create(params, config:)
    end

    # Get manifest by ID
    # @param manifest_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_manifest_by_id(manifest_id, config: {})
      @manifests.get_by_id(manifest_id, config:)
    end

    # Get manifest request by ID
    # @param request_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_manifest_request_by_id(request_id, config: {})
      @manifests.get_request_by_id(request_id, config:)
    end

    # ── Package Types ──────────────────────────────────────────────────

    # List custom package types
    # @param config [Hash?]
    # @return [Hash]
    def list_package_types(config: {})
      @package_types.list(config:)
    end

    # Create a custom package type
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_package_type(params, config: {})
      @package_types.create(params, config:)
    end

    # Get package type by ID
    # @param package_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_package_type_by_id(package_id, config: {})
      @package_types.get_by_id(package_id, config:)
    end

    # Update a package type
    # @param package_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_package_type(package_id, params, config: {})
      @package_types.update(package_id, params, config:)
    end

    # Delete a package type
    # @param package_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def delete_package_type(package_id, config: {})
      @package_types.delete(package_id, config:)
    end

    # ── Package Pickups ────────────────────────────────────────────────

    # List package pickups
    # @param params [Hash] - query params
    # @param config [Hash?]
    # @return [Hash]
    def list_package_pickups(params = {}, config: {})
      @package_pickups.list(params, config:)
    end

    # Schedule a package pickup
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def schedule_pickup(params, config: {})
      @package_pickups.schedule(params, config:)
    end

    # Get package pickup by ID
    # @param pickup_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_pickup_by_id(pickup_id, config: {})
      @package_pickups.get_by_id(pickup_id, config:)
    end

    # Delete a package pickup
    # @param pickup_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def delete_pickup(pickup_id, config: {})
      @package_pickups.delete(pickup_id, config:)
    end

    # ── Service Points ─────────────────────────────────────────────────

    # List service points
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def list_service_points(params, config: {})
      @service_points.list(params, config:)
    end

    # Get service point by ID
    # @param carrier_code [String]
    # @param country_code [String]
    # @param service_point_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_service_point_by_id(carrier_code, country_code, service_point_id, config: {})
      @service_points.get_by_id(carrier_code, country_code, service_point_id, config:)
    end

    # ── Insurance ──────────────────────────────────────────────────────

    # Get insurance balance
    # @param config [Hash?]
    # @return [Hash]
    def get_insurance_balance(config: {})
      @insurance.get_balance(config:)
    end

    # Add funds to insurance balance
    # @param params [Hash] - { currency:, amount: }
    # @param config [Hash?]
    # @return [Hash]
    def add_insurance_funds(params, config: {})
      @insurance.add_funds(params, config:)
    end

    # Connect Shipsurance
    # @param config [Hash?]
    # @return [Hash]
    def connect_insurance(config: {})
      @insurance.connect(config:)
    end

    # Disconnect Shipsurance
    # @param config [Hash?]
    # @return [Hash]
    def disconnect_insurance(config: {})
      @insurance.disconnect(config:)
    end

    # ── Tokens ─────────────────────────────────────────────────────────

    # Get an ephemeral token
    # @param config [Hash?]
    # @return [Hash]
    def get_ephemeral_token(config: {})
      @tokens.get_ephemeral_token(config:)
    end

    # ── Account ────────────────────────────────────────────────────────

    # Get account settings
    # @param config [Hash?]
    # @return [Hash]
    def get_account_settings(config: {})
      @account.get_settings(config:)
    end

    # Update account settings
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_account_settings(params, config: {})
      @account.update_settings(params, config:)
    end

    # List account images
    # @param config [Hash?]
    # @return [Hash]
    def list_account_images(config: {})
      @account.list_images(config:)
    end

    # Get account image by ID
    # @param image_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_account_image(image_id, config: {})
      @account.get_image(image_id, config:)
    end

    # Create an account image
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def create_account_image(params, config: {})
      @account.create_image(params, config:)
    end

    # Update an account image
    # @param image_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_account_image(image_id, params, config: {})
      @account.update_image(image_id, params, config:)
    end

    # Delete an account image
    # @param image_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def delete_account_image(image_id, config: {})
      @account.delete_image(image_id, config:)
    end

    # ── Carrier Accounts ───────────────────────────────────────────────

    # Connect a carrier account
    # @param carrier_name [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def connect_carrier_account(carrier_name, params, config: {})
      @carrier_accounts.connect(carrier_name, params, config:)
    end

    # Disconnect a carrier account
    # @param carrier_name [String]
    # @param carrier_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def disconnect_carrier_account(carrier_name, carrier_id, config: {})
      @carrier_accounts.disconnect(carrier_name, carrier_id, config:)
    end

    # Get carrier account settings
    # @param carrier_name [String]
    # @param carrier_id [String]
    # @param config [Hash?]
    # @return [Hash]
    def get_carrier_account_settings(carrier_name, carrier_id, config: {})
      @carrier_accounts.get_settings(carrier_name, carrier_id, config:)
    end

    # Update carrier account settings
    # @param carrier_name [String]
    # @param carrier_id [String]
    # @param params [Hash]
    # @param config [Hash?]
    # @return [Hash]
    def update_carrier_account_settings(carrier_name, carrier_id, params, config: {})
      @carrier_accounts.update_settings(carrier_name, carrier_id, params, config:)
    end

    # ── Documents ──────────────────────────────────────────────────────

    # Create a combined label document
    # @param params [Hash] - { label_ids: [...], ... }
    # @param config [Hash?]
    # @return [Hash]
    def create_combined_label_document(params, config: {})
      @documents.create_combined_label_document(params, config:)
    end

    # ── Downloads ──────────────────────────────────────────────────────

    # Download a file
    # @param subpath [String]
    # @param config [Hash?]
    # @return [Hash]
    def download_file(subpath, config: {})
      @downloads.download(subpath, config:)
    end
  end
end
