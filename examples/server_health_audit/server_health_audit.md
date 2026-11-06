# Server health audit

This example checks that a 1Password Connect server is alive, reports the state of the server and each of its dependencies, and summarises the most recent API requests by action and result.

## Prerequisites

### 1. Set up a 1Password Connect server

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-onepassword/blob/main/ballerina/README.md#setup-guide) to deploy a Connect server and create an access token.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
connectServerUrl = "<connect-server-url, e.g. http://localhost:8080/v1>"
connectToken = "<connect-access-token>"
activityLimit = 20
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
