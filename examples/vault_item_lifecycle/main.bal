// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// Finds a vault by name, stores a new login item in it, updates the item with a patch operation
// and removes it again when cleanup is enabled.

import ballerina/io;
import ballerinax/onepassword;

configurable string connectServerUrl = ?;
configurable string connectToken = ?;
configurable string vaultName = ?;
configurable string itemTitle = ?;
configurable string itemUsername = ?;
configurable string newItemTitle = ?;
configurable boolean deleteItemAfterwards = false;

public function main() returns error? {
    onepassword:Client connect = check new ({auth: {token: connectToken}}, connectServerUrl);

    // Step 1: locate the vault by name.
    onepassword:Vault[] vaults = check connect->listVaults(filter = string `name eq "${scimString(vaultName)}"`);
    if vaults.length() == 0 {
        return error(string `No vault named ${vaultName} is visible to this token`);
    }
    string vaultId = vaults[0]?.id ?: "";
    if vaultId == "" {
        return error("The matching vault has no id");
    }
    io:println("Using vault: ", vaults[0]?.name, " (", vaultId, ")");

    // Step 2: create a login item.
    onepassword:FullItem created = check connect->createItem(vaultId, {
        title: itemTitle,
        category: "LOGIN",
        vault: {id: vaultId},
        fields: [
            {id: "username", 'type: "STRING", purpose: "USERNAME", value: itemUsername},
            {id: "password", 'type: "CONCEALED", purpose: "PASSWORD", generate: true}
        ]
    });
    string itemId = created?.id ?: "";
    if itemId == "" {
        return error("The created item has no id");
    }
    io:println("Created item: ", created?.title, " (", itemId, ")");

    // Step 3: rename the item with a patch operation.
    onepassword:FullItem renamed = check connect->patchItem(vaultId, itemId, [
        {op: "replace", path: "/title", value: newItemTitle}
    ]);
    io:println("Item title is now: ", renamed?.title);

    // Step 4: list the items in the vault to confirm it is there.
    onepassword:Item[] items = check connect->listItems(vaultId, filter = string `title eq "${scimString(newItemTitle)}"`);
    io:println("Items matching the new title: ", items.length());

    if deleteItemAfterwards {
        check connect->deleteItem(vaultId, itemId);
        io:println("Deleted item ", itemId);
    }
}

// Escapes a value for use inside a double-quoted SCIM filter string, so embedded quotes or
// backslashes cannot change the filter's syntax.
function scimString(string value) returns string {
    string escaped = "";
    foreach string:Char c in value {
        escaped += c == "\\" || c == "\"" ? "\\" + c : c;
    }
    return escaped;
}
