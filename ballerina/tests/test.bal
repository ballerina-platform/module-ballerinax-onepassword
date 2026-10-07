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
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? os:getEnv("ONEPASSWORD_SERVER_URL") : "http://localhost:9090";
final string connectToken = isLiveServer ? os:getEnv("ONEPASSWORD_CONNECT_TOKEN") : "test_token";
final string liveVaultId = os:getEnv("ONEPASSWORD_VAULT_ID");

final Client onePassword = check new ({auth: {token: connectToken}, httpVersion: http:HTTP_1_1}, serviceUrl);

function getVaultId() returns string {
    return isLiveServer ? liveVaultId : "ftz4pm2xkpbvhcxxuq5xnbh3wq";
}

function newItemRequest() returns FullItem => {
    title: "Test Login",
    category: "LOGIN",
    vault: {id: getVaultId()},
    fields: [{id: "username", 'type: "STRING", purpose: "USERNAME", value: "tester"}]
};

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListApiActivity() returns error? {
    APIRequest[] response = check onePassword->listApiActivity();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListVaults() returns error? {
    Vault[] response = check onePassword->listVaults();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetVault() returns error? {
    Vault response = check onePassword->getVault(getVaultId());
    test:assertTrue(response?.id !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListItems() returns error? {
    Item[] response = check onePassword->listItems(getVaultId());
    test:assertTrue(response.length() >= 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateItem() returns error? {
    FullItem response = check onePassword->createItem(getVaultId(), newItemRequest());
    test:assertTrue(response?.id !is ());
    if isLiveServer {
        check onePassword->deleteItem(getVaultId(), <string>response?.id);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetItem() returns error? {
    FullItem created = check onePassword->createItem(getVaultId(), newItemRequest());
    FullItem response = check onePassword->getItem(getVaultId(), created?.id ?: "bsxkq7d2mnvh4rjw5ylcz3ptae");
    test:assertTrue(response?.id !is ());
    if isLiveServer {
        check onePassword->deleteItem(getVaultId(), <string>created?.id);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testUpdateItem() returns error? {
    FullItem created = check onePassword->createItem(getVaultId(), newItemRequest());
    FullItem request = newItemRequest();
    request.title = "Updated Login";
    request.id = created?.id;
    FullItem response = check onePassword->updateItem(getVaultId(), created?.id ?: "bsxkq7d2mnvh4rjw5ylcz3ptae", request);
    test:assertTrue(response?.id !is ());
    if isLiveServer {
        check onePassword->deleteItem(getVaultId(), <string>created?.id);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testPatchItem() returns error? {
    FullItem created = check onePassword->createItem(getVaultId(), newItemRequest());
    FullItem response = check onePassword->patchItem(getVaultId(), created?.id ?: "bsxkq7d2mnvh4rjw5ylcz3ptae",
        [{op: "replace", path: "/title", value: "Updated Title"}]);
    test:assertTrue(response?.id !is ());
    if isLiveServer {
        check onePassword->deleteItem(getVaultId(), <string>created?.id);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeleteItem() returns error? {
    FullItem created = check onePassword->createItem(getVaultId(), newItemRequest());
    error? response = onePassword->deleteItem(getVaultId(), created?.id ?: "bsxkq7d2mnvh4rjw5ylcz3ptae");
    test:assertTrue(response is ());
}

@test:Config {groups: ["mock_tests"]}
function testListItemFiles() returns error? {
    File[] response = check onePassword->listItemFiles(getVaultId(), "bsxkq7d2mnvh4rjw5ylcz3ptae");
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testGetItemFile() returns error? {
    File response = check onePassword->getItemFile(getVaultId(), "bsxkq7d2mnvh4rjw5ylcz3ptae", "gk3x7m2vdq5rjh8nwy4ctbpe6a");
    test:assertTrue(response?.id !is ());
}

@test:Config {groups: ["mock_tests"]}
function testDownloadItemFile() returns error? {
    byte[] response = check onePassword->downloadItemFile(getVaultId(), "bsxkq7d2mnvh4rjw5ylcz3ptae", "gk3x7m2vdq5rjh8nwy4ctbpe6a");
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetHeartbeat() returns error? {
    string response = check onePassword->getHeartbeat();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetServerHealth() returns error? {
    ServerHealth response = check onePassword->getServerHealth();
    test:assertTrue(response.name.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetPrometheusMetrics() returns error? {
    string response = check onePassword->getPrometheusMetrics();
    test:assertTrue(response.length() > 0);
}
