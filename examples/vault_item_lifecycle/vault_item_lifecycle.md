# Vault item lifecycle

This example finds a vault by name, creates a login item in it with a generated password, renames the item with a patch operation, lists the vault's items to confirm the change, and optionally deletes the item again.

## Prerequisites

### 1. Set up a 1Password Connect server

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-onepassword/blob/main/ballerina/README.md#setup-guide) to deploy a Connect server and create an access token. The token needs read and write access to the vault used in this example.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
connectServerUrl = "<connect-server-url, e.g. http://localhost:8080/v1>"
connectToken = "<connect-access-token>"
vaultName = "<vault-name>"
itemTitle = "<new-item-title>"
itemUsername = "<login-username>"
newItemTitle = "<renamed-item-title>"
deleteItemAfterwards = false
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
