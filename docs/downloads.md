# Downloads

Retrieve files such as labels, documents, and manifests. Use the subpath from a label's `label_download` href or other download URLs.

## download

Downloads a file by subpath. The subpath is typically obtained from a label's `label_download` href or document URL returned by other API calls.

**Method:** `client.downloads.download(subpath, config: {})`

**API Endpoint:** `GET /v1/downloads/{subpath}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| subpath | String | Yes | The download path (e.g., from label_download href or document URL) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
# Download a label file using the subpath from a label's label_download href
file = client.downloads.download('labels/123/4')
```

### Response

Returns the raw file content (e.g., PDF binary for labels). The content type depends on the resource being downloaded.
