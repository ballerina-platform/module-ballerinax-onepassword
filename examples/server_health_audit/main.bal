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

// Checks that a 1Password Connect server is alive and healthy, then summarises the most recent
// API requests it has served.

import ballerina/io;
import ballerinax/onepassword;

configurable string connectServerUrl = ?;
configurable string connectToken = ?;
configurable int activityLimit = 20;

public function main() returns error? {
    onepassword:Client connect = check new ({auth: {token: connectToken}}, connectServerUrl);

    // Step 1: liveness probe.
    string heartbeat = check connect->getHeartbeat();
    io:println("Heartbeat: ", heartbeat);

    // Step 2: report server and dependency health.
    onepassword:ServerHealth health = check connect->getServerHealth();
    io:println("Server: ", health.name, " ", health.version);
    foreach onepassword:ServiceDependency dependency in health.dependencies ?: [] {
        io:println("  ", dependency?.'service, ": ", dependency?.status, " - ", dependency?.message);
    }

    // Step 3: summarise recent API activity by action and result.
    onepassword:APIRequest[] activity = check connect->listApiActivity('limit = activityLimit);
    map<int> counts = {};
    foreach onepassword:APIRequest request in activity {
        string key = string `${request?.action ?: "UNKNOWN"}/${request?.result ?: "UNKNOWN"}`;
        counts[key] = (counts[key] ?: 0) + 1;
    }
    io:println("Requests inspected: ", activity.length());
    foreach [string, int] [key, count] in counts.entries() {
        io:println("  ", key, ": ", count);
    }
}
