---
title: "Velocitas automated tests"
date: 2022-05-09T13:46:21+05:30
weight: 60
description: >
  Learn about automated testing of our Vehicle App Templates.
aliases:
  - /docs/concepts/lifecycle_management/automated_tests
---

To be sure that our provided devcontainers for templates work as expected we have developed automated tests.

Automated tests contain:
- Requirements tests
- Runtimes tests
- Integration tests

### Requirements tests
Requirements tests test availability of required dependencies.

### Runtimes tests
Runtimes tests test functionality of each particular runtime.

### Integration tests
Integration tests executes as part of runtimes tests for each particular runtime to ensure that provided _Vehicle App_ runs together with other services.

## Automated Tests as a workflow

The tests are discovered and executed automatically in the provided [Devcontainer check](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.github/workflows/check-devcontainer.yml).


## Next steps

- Concept: [Deployment Model](/docs/concepts/deployment_model/)
- Concept: [Build and release process](/docs/concepts/deployment_model/vehicle_app_releases/)
- Tutorial: [Deploy a Python _Vehicle App_ with Helm](/docs/tutorials/vehicle_app_deployment/helm_deployment.md)
