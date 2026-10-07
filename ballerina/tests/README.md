# Running Tests

## Prerequisites

The tests run against a mock 1Password Connect server (defined in `tests/mock_service.bal`) by default, so no account or credentials are needed.

## Running the tests

### Mock server (default)

```bash
bal test --groups mock_tests
```

The mock server listens on port 9090 and starts automatically with the test run. It covers vaults, items (create, get, update, patch, delete), item files, API activity, server health, heartbeat and metrics.

### Live server

To run the tests against a real Connect server, set the following environment variables and run the live test group:

| Variable | Description |
|---|---|
| `IS_LIVE_SERVER` | Set to `true` to use the real server |
| `ONEPASSWORD_SERVER_URL` | Connect server URL, for example `http://localhost:8080/v1` |
| `ONEPASSWORD_CONNECT_TOKEN` | Connect access token with read and write access to the test vault |
| `ONEPASSWORD_VAULT_ID` | ID of the vault used by the item tests |

```bash
export IS_LIVE_SERVER=true
export ONEPASSWORD_SERVER_URL="<connect-server-url>"
export ONEPASSWORD_CONNECT_TOKEN="<connect-access-token>"
export ONEPASSWORD_VAULT_ID="<vault-id>"
bal test --groups live_tests
```

Tests that create items remove them again. The file tests run against the mock server only, because they need an item with an attached file.
