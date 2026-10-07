# Ballerina 1Password connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-onepassword/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-onepassword/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-onepassword.svg)](https://github.com/ballerina-platform/module-ballerinax-onepassword/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/onepassword.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fonepassword)

## Overview

[1Password](https://1password.com/) is a password manager and secrets platform for individuals, teams and businesses. [1Password Connect](https://developer.1password.com/docs/connect/) is a self-hosted server that exposes a REST API for reading and managing the vaults, items and files in a 1Password account, so that applications and infrastructure can retrieve secrets without a 1Password client.

The 1Password connector lets Ballerina applications call the Connect server's REST API. It supports version 1.7.1 of the 1Password Connect API.

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`onepassword` package](https://central.ballerina.io/ballerinax/onepassword/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
