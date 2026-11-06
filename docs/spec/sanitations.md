_Author_:  @Dimuthu Madushan \
_Created_: 2026/10/07 \
_Updated_: 2026/10/07 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from 1Password.
The OpenAPI specification is obtained from [1Password Connect API 1.7.1](https://github.com/wso2/api-specs/blob/main/openapi/1password/connect/1.7.1/openapi.yaml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Allow any JSON value for the `value` property of a patch operation (`PatchInner`).

   **Original**

   ```yaml
   value:
     type: object
   ```

   **Updated**

   ```yaml
   value:
     description: The new value for the attribute or field. It can be any JSON value
   ```

   **Reason**: A patch operation sets an attribute or a field to a string, boolean or number as often as to an object (for example replacing `/title` or `/fields/<id>/value`). Typing the value as an object made those patches impossible to express and generated `record {}`; without a type it generates `anydata`.

2. Replace the generic `Success` description of the file content response (`GET /vaults/{vaultUuid}/items/{itemUuid}/files/{fileUuid}/content`, `200`).

   **Original**

   ```yaml
   "200":
     description: "Success"
   ```

   **Updated**

   ```yaml
   "200":
     description: "The raw content of the file"
   ```

   **Reason**: The response returns a body, so the description should say what it contains.

3. Rename the operation IDs to concise, intent-revealing camelCase names (applied by the generating-connectors skill and persisted in `ai-mappings.json`).

   | Original | Updated |
   |---|---|
   | `GetApiActivity` | `listApiActivity` |
   | `GetVaults` | `listVaults` |
   | `GetVaultById` | `getVault` |
   | `GetVaultItems` | `listItems` |
   | `CreateVaultItem` | `createItem` |
   | `GetVaultItemById` | `getItem` |
   | `UpdateVaultItem` | `updateItem` |
   | `PatchVaultItem` | `patchItem` |
   | `DeleteVaultItem` | `deleteItem` |
   | `GetItemFiles` | `listItemFiles` |
   | `GetDetailsOfFileById` | `getItemFile` |
   | `DownloadFileByID` | `downloadItemFile` |
   | `GetHeartbeat` | `getHeartbeat` |
   | `GetServerHealth` | `getServerHealth` |
   | `GetPrometheusMetrics` | `getPrometheusMetrics` |

   **Reason**: The original IDs are PascalCase and inconsistent about naming collection and single-item reads.

4. Rename generated schemas to descriptive names (applied by flatten/align and the skill's schema mapping).

   | Original | Updated |
   |---|---|
   | `InlineResponse200` (response of `GET /health`) | `ServerHealth` |
   | `Patch` (request body of `PATCH /vaults/{vaultUuid}/items/{itemUuid}`) | `PatchItemRequest` |

   **Reason**: Replace the generic generated name and name the request body after its operation.

5. Add missing descriptions so that the generated client and types are fully documented (no undocumented parameter or field warnings).

   - Request body descriptions: `POST /vaults/{vaultUuid}/items` ("The Item to create, including its fields, sections and URLs"), `PUT /vaults/{vaultUuid}/items/{itemUuid}` ("The complete Item to store in place of the existing one") and `PATCH /vaults/{vaultUuid}/items/{itemUuid}` ("The list of patch operations to apply to the Item").
   - Property descriptions: `GeneratorRecipe.characterSets`, `File.section.id`, `ServiceDependency.service` and `ServiceDependency.status`.
   - Property descriptions on `APIRequest`: `action`, `result`, `actor` (with `id`, `account`, `jti`, `userAgent`, `requestIp`) and `resource` (with `type`, `vault`, `vault.id`, `item`, `item.id`, `itemVersion`).

   **Original**

   ```yaml
   requestBody:
     content:
       application/json:
         schema:
           $ref: "#/components/schemas/FullItem"
   ```

   **Updated**

   ```yaml
   requestBody:
     description: The Item to create, including its fields, sections and URLs
     content:
       application/json:
         schema:
           $ref: "#/components/schemas/FullItem"
   ```

   **Reason**: Without descriptions, `bal build` warns about undocumented parameters and fields.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```
Note: The license year is hardcoded to 2026, change if necessary.
