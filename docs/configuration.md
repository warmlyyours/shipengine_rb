# Configuration

Client initialization, configuration options, per-request overrides, error handling, and retry behavior.

## Client Initialization

The client accepts an API key (required) and optional configuration parameters:

```ruby
# Minimal: API key only
client = ShipEngineRb::Client.new('YOUR_API_KEY')

# Full configuration
client = ShipEngineRb::Client.new(
  'YOUR_API_KEY',
  retries: 3,
  timeout: 60_000,
  page_size: 50,
  base_url: 'https://api.shipengine.com'
)
```

### Constructor Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| api_key | String | Yes | Your ShipEngine API key for authentication |
| retries | Integer | No | Number of retries for rate-limited (429) requests |
| timeout | Integer | No | Request timeout in milliseconds |
| page_size | Integer | No | Default page size for paginated endpoints |
| base_url | String | No | Base URL for the API (defaults to production) |

## Default Values

| Option | Default | Description |
|--------|---------|-------------|
| api_key | — | Required; no default |
| retries | 1 | Retry once on 429 rate limit responses |
| timeout | 60,000 | 60 seconds (value is in milliseconds) |
| page_size | 50 | Items per page for paginated endpoints |
| base_url | `https://api.shipengine.com` | ShipEngine production API |

## Validation Rules

The following validations are applied at client instantiation and at method call time:

- **api_key**: Must be specified (non-nil, non-empty). Raises `ValidationError` with code `FIELD_VALUE_REQUIRED` if missing.
- **retries**: Must be zero or greater. Raises `ValidationError` with code `INVALID_FIELD_VALUE` if negative.
- **timeout**: Must be greater than zero. Raises `ValidationError` with code `INVALID_FIELD_VALUE` if zero or negative.
- **page_size**: Must be greater than zero. Raises `ValidationError` with code `INVALID_FIELD_VALUE` if zero or negative.

## Per-Request Config Overrides

You can override configuration for individual requests by passing a `config` hash as the last argument to any domain method:

```ruby
client = ShipEngineRb::Client.new('YOUR_API_KEY', timeout: 60_000)

# Use a different API key for this request
client.addresses.validate(params, config: { api_key: 'other_api_key' })

# Override timeout for a slow operation
client.shipments.list(config: { timeout: 120_000 })

# Override multiple options
client.addresses.validate(params, config: {
  api_key: 'baz',
  timeout: 222_000,
  retries: 2,
  page_size: 25
})
```

Per-request overrides do not mutate the client's global configuration. The client merges the override with the current config only for that request.

## Error Handling

The gem raises exceptions for API errors. All ShipEngine exceptions inherit from `ShipEngineRb::Exceptions::ShipEngineError`.

### Exception Classes

| Class | When Raised |
|-------|-------------|
| `ShipEngineRb::Exceptions::ShipEngineError` | Base class; raised for 400, 401, 404, 500, 502, 503, 504 |
| `ShipEngineRb::Exceptions::ValidationError` | Validation failures (e.g., invalid api_key, page_size, timeout) |
| `ShipEngineRb::Exceptions::RateLimitError` | 429 rate limit exceeded (after retries exhausted) |
| `ShipEngineRb::Exceptions::TimeoutError` | Request timeout |
| `ShipEngineRb::Exceptions::BusinessRulesError` | Business rule violations |
| `ShipEngineRb::Exceptions::AccountStatusError` | Account status issues |
| `ShipEngineRb::Exceptions::SecurityError` | Security-related errors |
| `ShipEngineRb::Exceptions::SystemError` | General system errors |

### Catching Errors

```ruby
begin
  response = client.shipments.create(params)
rescue ShipEngineRb::Exceptions::ValidationError => e
  puts "Validation failed: #{e.message}"
  puts "Error code: #{e.code}"
rescue ShipEngineRb::Exceptions::RateLimitError => e
  puts "Rate limited: #{e.message}"
  puts "Retries attempted: #{e.retries}"
rescue ShipEngineRb::Exceptions::ShipEngineError => e
  puts "API error: #{e.message}"
  puts "Request ID: #{e.request_id}"
  puts "Source: #{e.source}, Type: #{e.type}, Code: #{e.code}"
end
```

### Rate Limit Error Details

`RateLimitError` includes a `retries` attribute indicating how many retries were attempted before the error was raised:

```ruby
rescue ShipEngineRb::Exceptions::RateLimitError => e
  puts "Rate limit exceeded after #{e.retries} retries"
end
```

## Rate Limiting and Retry Behavior

When the API returns HTTP 429 (rate limit exceeded), the client automatically retries according to the configured `retries` value.

### Retry Logic

- **Default**: 1 retry (2 total attempts)
- **Retry-After header**: If the API includes a `Retry-After` header (in seconds), the client waits that duration before retrying
- **retryAfter in error body**: If the error body includes `retryAfter: 0`, retries happen immediately without delay
- **Methods retried**: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS
- **When retries are exhausted**: `RateLimitError` is raised

### Examples

```ruby
# Disable retries (fail immediately on 429)
client = ShipEngineRb::Client.new('YOUR_API_KEY', retries: 0)

# Allow 2 retries (3 total attempts)
client = ShipEngineRb::Client.new('YOUR_API_KEY', retries: 2)
```

### Rate Limit Error Response

When rate limited, the API returns a response like:

```json
{
  "request_id": "7b80b28f-80d2-4175-ad99-7c459980539f",
  "errors": [
    {
      "error_source": "shipengine",
      "error_type": "system",
      "error_code": "rate_limit_exceeded",
      "message": "You have exceeded the rate limit. Please see https://www.shipengine.com/docs/rate-limits"
    }
  ]
}
```

After retries are exhausted, this results in a `RateLimitError` with message `"You have exceeded the rate limit."`.
