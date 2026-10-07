## Overview

[1Password](https://1password.com/) is a password manager and secrets platform for individuals, teams and businesses. [1Password Connect](https://developer.1password.com/docs/connect/) is a self-hosted server that exposes a REST API for reading and managing the vaults, items and files in a 1Password account, so that applications and infrastructure can retrieve secrets without a 1Password client.

The 1Password connector lets Ballerina applications call the Connect server's REST API. It supports version 1.7.1 of the 1Password Connect API.

### Key features

- List vaults and read vault details and metadata
- Create, read, update, patch and delete items, including their fields, sections and URLs
- List the files attached to an item, read their details and download their content
- Review the API requests made against the Connect server
- Check the server's liveness, dependency health and Prometheus metrics

## Setup guide

To use the 1Password connector, you need a 1Password account and a running 1Password Connect server.

### Step 1: Create a Connect server

1. Sign in to your account on [1Password.com](https://1password.com/) and open **Developer** → **Infrastructure Secrets** → **Other** (the Connect server option).
2. Select **Create a Connect server**, name the server and choose the vaults it may access.
3. Download the generated `1password-credentials.json` file and keep it safe.

### Step 2: Deploy the Connect server

Deploy the server with the credentials file as described in the [Connect server deployment guide](https://developer.1password.com/docs/connect/get-started/#step-2-deploy-1password-connect-server). By default, the server listens on port `8080` and serves the API under `/v1`.

### Step 3: Create an access token

1. In the same Connect server settings, select **Create access token**.
2. Name the token, choose the vaults it can read or write, and copy the token value. It is shown only once.

You will use the Connect server's address and this token to configure the connector.

## Quickstart

To use the 1Password connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `onepassword` module.

```ballerina
import ballerinax/onepassword;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the values obtained in the steps above:

```toml
connectServerUrl = "<Connect server URL, e.g. http://localhost:8080/v1>"
connectToken = "<Connect access token>"
```

2. Create an `onepassword:ConnectionConfig` with the access token and initialize the connector with the server URL.

```ballerina
configurable string connectServerUrl = ?;
configurable string connectToken = ?;

final onepassword:Client onePassword = check new ({auth: {token: connectToken}}, connectServerUrl);
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### List the vaults

```ballerina
public function main() returns error? {
    onepassword:Vault[] _ = check onePassword->listVaults();
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The 1Password connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-onepassword/tree/main/examples/), covering the following use cases:

1. [Vault item lifecycle](https://github.com/ballerina-platform/module-ballerinax-onepassword/tree/main/examples/vault_item_lifecycle) - Find a vault by name, create a login item with a generated password, rename it with a patch operation and optionally delete it.

2. [Server health audit](https://github.com/ballerina-platform/module-ballerinax-onepassword/tree/main/examples/server_health_audit) - Check a Connect server's liveness and dependency health, and summarise its recent API activity.
