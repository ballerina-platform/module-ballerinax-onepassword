# Change Log

This file contains all the notable changes done to the Ballerina 1Password connector through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Remote-method client covering the full 1Password Connect 1.7.1 API: vaults, items, item files, API activity, server
  health, heartbeat and Prometheus metrics.
- Bearer-token authentication through `ConnectionConfig.auth`.
- Mock server tests and two examples.
