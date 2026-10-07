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

import ballerina/http;

listener http:Listener ep0 = new (9090);

const string VAULT_ID = "ftz4pm2xkpbvhcxxuq5xnbh3wq";
const string ITEM_ID = "bsxkq7d2mnvh4rjw5ylcz3ptae";
const string FILE_ID = "gk3x7m2vdq5rjh8nwy4ctbpe6a";

function mockItem() returns Item => {
    id: ITEM_ID,
    title: "Production Database",
    category: "DATABASE",
    favorite: false,
    version: 2,
    vault: {id: VAULT_ID},
    tags: ["production", "database"],
    urls: [{label: "Console", href: "https://db.example.com", primary: true}],
    createdAt: "2026-01-15T09:30:00Z",
    updatedAt: "2026-02-01T14:05:00Z",
    lastEditedBy: "h7p2rjx4kwmq9vdn3ctybze5ua"
};

function mockFullItem() returns FullItem {
    FullItem item = {...mockItem()};
    item.fields = [
        {id: "username", label: "username", 'type: "STRING", purpose: "USERNAME", value: "admin"},
        {id: "password", label: "password", 'type: "CONCEALED", purpose: "PASSWORD", value: "s3cr3t-Passw0rd"}
    ];
    item.sections = [{id: "details", label: "Details"}];
    item.files = [mockFile()];
    return item;
}

function mockFile() returns File => {
    id: FILE_ID,
    name: "credentials.txt",
    size: 17,
    contentPath: "v1/vaults/" + VAULT_ID + "/items/" + ITEM_ID + "/files/" + FILE_ID + "/content",
    section: {id: "details"}
};

function mockVault() returns Vault => {
    id: VAULT_ID,
    name: "Engineering",
    description: "Secrets used by the engineering team",
    'type: "USER_CREATED",
    attributeVersion: 1,
    contentVersion: 12,
    items: 8,
    createdAt: "2026-01-10T08:00:00Z",
    updatedAt: "2026-02-01T14:05:00Z"
};

@http:ServiceConfig {treatNilableAsOptional: true}
service / on ep0 {
    # Delete an Item
    #
    # + vaultUuid - The UUID of the Vault the item is in
    # + itemUuid - The UUID of the Item to update
    # + return - returns can be any of following types 
    # http:NoContent (Successfully deleted an item)
    # http:Unauthorized (Invalid or missing token)
    # http:Forbidden (Unauthorized access)
    # http:NotFound (Item not found)
    resource function delete vaults/[string vaultUuid]/items/[string itemUuid]() returns http:NoContent|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound {
        return http:NO_CONTENT;
    }

    # Retrieve a list of API Requests that have been made.
    #
    # + 'limit - How many API Events should be retrieved in a single request
    # + offset - How far into the collection of API Events should the response start
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:Unauthorized (Invalid or missing token)
    resource function get activity(int 'limit = 50, int offset = 0) returns APIRequest[]|ErrorResponseUnauthorized {
        return [
            {
                result: "SUCCESS",
                actor: {userAgent: "OPConnect/1.7.1", requestIp: "10.0.0.12", id: "h7p2rjx4kwmq9vdn3ctybze5ua", account: "acct-4821", jti: "7d1c0f52-9a3b-4f1e-8c2d-5b6e7a8f9c01"},
                'resource: {'type: "ITEM", item: {id: ITEM_ID}, itemVersion: 2, vault: {id: VAULT_ID}},
                requestId: "e2b1c3d4-5f6a-4b7c-8d9e-0a1b2c3d4e5f",
                action: "READ",
                timestamp: "2026-02-01T14:05:00Z"
            }
        ];
    }

    # Get state of the server and its dependencies.
    #
    # + return - OK 
    resource function get health() returns ServerHealth {
        return {
            name: "1Password Connect API",
            version: "1.7.1",
            dependencies: [
                {'service: "sync", status: "ACTIVE", message: "Connected to 1Password"},
                {'service: "sqlite", status: "ACTIVE", message: "Database is healthy"}
            ]
        };
    }

    # Ping the server for liveness
    #
    # + return - OK 
    resource function get heartbeat() returns string {
        return ".";
    }

    # Query server for exposed Prometheus metrics
    #
    # + return - Successfully returned Prometheus metrics 
    resource function get metrics() returns string {
        return "# HELP op_connect_requests_total Total number of API requests\n# TYPE op_connect_requests_total counter\nop_connect_requests_total 42\n";
    }

    # Get all Vaults
    #
    # + filter - Filter the Vault collection based on Vault name using SCIM eq filter
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:Unauthorized (Invalid or missing token)
    resource function get vaults(string? filter) returns Vault[]|ErrorResponseUnauthorized {
        return [mockVault()];
    }

    # Get Vault details and metadata
    #
    # + vaultUuid - The UUID of the Vault to fetch Items from
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:Unauthorized (Invalid or missing token)
    # http:Forbidden (Unauthorized access)
    # http:NotFound (Vault not found)
    resource function get vaults/[string vaultUuid]() returns Vault|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound {
        return mockVault();
    }

    # Get all items for inside a Vault
    #
    # + vaultUuid - The UUID of the Vault to fetch Items from
    # + filter - Filter the Item collection based on Item name using SCIM eq filter
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:Unauthorized (Invalid or missing token)
    # http:NotFound (Vault not found)
    resource function get vaults/[string vaultUuid]/items(string? filter) returns Item[]|ErrorResponseUnauthorized|ErrorResponseNotFound {
        return [mockItem()];
    }

    # Get the details of an Item
    #
    # + vaultUuid - The UUID of the Vault to fetch Item from
    # + itemUuid - The UUID of the Item to fetch
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:Unauthorized (Invalid or missing token)
    # http:Forbidden (Unauthorized access)
    # http:NotFound (Item not found)
    resource function get vaults/[string vaultUuid]/items/[string itemUuid]() returns FullItem|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound {
        return mockFullItem();
    }

    # Get all the files inside an Item
    #
    # + vaultUuid - The UUID of the Vault to fetch Items from
    # + itemUuid - The UUID of the Item to fetch files from
    # + inlineFiles - Tells server to return the base64-encoded file contents in the response
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:Unauthorized (Invalid or missing token)
    # http:NotFound (Item not found)
    # http:PayloadTooLarge (File content too large to display)
    resource function get vaults/[string vaultUuid]/items/[string itemUuid]/files(@http:Query {name: "inline_files"} boolean? inlineFiles) returns File[]|ErrorResponseUnauthorized|ErrorResponseNotFound|ErrorResponsePayloadTooLarge {
        return [mockFile()];
    }

    # Get the details of a File
    #
    # + vaultUuid - The UUID of the Vault to fetch Item from
    # + itemUuid - The UUID of the Item to fetch File from
    # + fileUuid - The UUID of the File to fetch
    # + inlineFiles - Tells server to return the base64-encoded file contents in the response
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:Unauthorized (Invalid or missing token)
    # http:Forbidden (Unauthorized access)
    # http:NotFound (File not found)
    # http:PayloadTooLarge (File content too large to display)
    resource function get vaults/[string vaultUuid]/items/[string itemUuid]/files/[string fileUuid](@http:Query {name: "inline_files"} boolean? inlineFiles) returns File|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound|ErrorResponsePayloadTooLarge {
        return mockFile();
    }

    # Get the content of a File
    #
    # + vaultUuid - The UUID of the Vault the item is in
    # + itemUuid - The UUID of the Item the File is in
    # + fileUuid - UUID of the file to get content from
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Invalid or missing token)
    # http:NotFound (File not found)
    resource function get vaults/[string vaultUuid]/items/[string itemUuid]/files/[string fileUuid]/content() returns byte[]|ErrorResponseUnauthorized|ErrorResponseNotFound {
        return "mock file content".toBytes();
    }

    # Update a subset of Item attributes
    #
    # + vaultUuid - The UUID of the Vault the item is in
    # + itemUuid - The UUID of the Item to update
    # + return - returns can be any of following types 
    # http:Ok (OK - Item updated. If no Patch operations were provided, Item is unmodified)
    # http:Unauthorized (Invalid or missing token)
    # http:Forbidden (Unauthorized access)
    # http:NotFound (Item not found)
    resource function patch vaults/[string vaultUuid]/items/[string itemUuid](@http:Payload PatchItemRequest payload) returns FullItem|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound {
        FullItem item = mockFullItem();
        foreach PatchInner op in payload {
            if op.op == "replace" && op.path == "/title" {
                item.title = "Updated Title";
            }
        }
        return item;
    }

    # Create a new Item
    #
    # + vaultUuid - The UUID of the Vault to create an Item in
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:BadRequest (Unable to create item due to invalid input)
    # http:Unauthorized (Invalid or missing token)
    # http:Forbidden (Unauthorized access)
    # http:NotFound (Item not found)
    resource function post vaults/[string vaultUuid]/items(@http:Payload FullItem payload) returns FullItemOk|ErrorResponseBadRequest|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound {
        FullItem item = mockFullItem();
        item.title = payload.title ?: item.title;
        item.category = payload.category;
        return {body: item};
    }

    # Update an Item
    #
    # + vaultUuid - The UUID of the Item's Vault
    # + itemUuid - The UUID of the Item to update
    # + return - returns can be any of following types 
    # http:Ok (OK)
    # http:BadRequest (Unable to create item due to invalid input)
    # http:Unauthorized (Invalid or missing token)
    # http:Forbidden (Unauthorized access)
    # http:NotFound (Item not found)
    resource function put vaults/[string vaultUuid]/items/[string itemUuid](@http:Payload FullItem payload) returns FullItem|ErrorResponseBadRequest|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound {
        FullItem item = mockFullItem();
        item.title = payload.title ?: item.title;
        item.category = payload.category;
        return item;
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ErrorResponseBadRequest record {|
    *http:BadRequest;
    ErrorResponse body;
|};

public type ErrorResponseForbidden record {|
    *http:Forbidden;
    ErrorResponse body;
|};

public type ErrorResponseNotFound record {|
    *http:NotFound;
    ErrorResponse body;
|};

public type ErrorResponsePayloadTooLarge record {|
    *http:PayloadTooLarge;
    ErrorResponse body;
|};

public type ErrorResponseUnauthorized record {|
    *http:Unauthorized;
    ErrorResponse body;
|};

public type FullItemOk record {|
    *http:Ok;
    FullItem body;
|};

public type ErrorResponse record {
    # A message detailing the error
    string message?;
    # HTTP Status Code
    int status?;
};
