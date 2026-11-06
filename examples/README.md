# Examples

The `ballerinax/onepassword` connector provides practical examples illustrating usage in various scenarios.

1. **[Vault item lifecycle](https://github.com/ballerina-platform/module-ballerinax-onepassword/tree/main/examples/vault_item_lifecycle)** - Find a vault by name, create a login item with a generated password, rename it with a patch operation and optionally delete it.

2. **[Server health audit](https://github.com/ballerina-platform/module-ballerinax-onepassword/tree/main/examples/server_health_audit)** - Check a Connect server's liveness and dependency health, and summarise its recent API activity.

## Prerequisites

1. Deploy a 1Password Connect server and create an access token as described in the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-onepassword/blob/main/ballerina/README.md#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
connectServerUrl = "<connect-server-url>"
connectToken = "<connect-access-token>"
```

Each example lists the additional values it needs in its own README.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
