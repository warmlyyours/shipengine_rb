# Tokens

Obtain ephemeral tokens for temporary API access.

## get_ephemeral_token

Gets an ephemeral token for short-lived API authentication.

**Method:** `client.tokens.get_ephemeral_token(config: {})`

**API Endpoint:** `POST /v1/tokens/ephemeral`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.tokens.get_ephemeral_token
```

### Response

```json
{
  "token": "ephemeral_token_xyz"
}
```
