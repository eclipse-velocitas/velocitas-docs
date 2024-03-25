---
title: "Vehicle App Integration Testing"
date: 2022-05-09T13:46:21+05:30
weight: 60
description: >
  Learn how to test that a _Vehicle App_ together with the KUKSA Data Broker and potentially other dependant Vehicle Services or _Vehicle Apps_ runs as expected.
aliases:
  - /docs/tutorials/vehicle_app_development/integration_tests
---

To be sure that a newly created _Vehicle App_ will run together with the _KUKSA Data Broker_ and potentially other dependant _Vehicle Services_ or _Vehicle Apps_, it's essential to write integration tests along with developing the app.

To execute an integration test, the dependant components need to be running and be accessible from the test runner. This guide will describe how integration tests can be written and integrated in the CI pipeline so that they are executed automatically when building the application.

{{% alert title="Note" %}}
This guide is currently only available for development of integration tests with **Python**.
{{% /alert %}}

## Writing Test Cases

To write an integration test, you should check the sample that comes with the template ([`/app/tests/integration/integration_test.py`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/app/tests/integration/integration_test.py)). To support interacting with the MQTT broker and the KUKSA Data Broker (to get and set values for data points), there are two classes present in Python SDK that will help:

- `MqttClient`: this class provides methods for interacting with the MQTT broker. Currently, the following methods are available:

  - `publish_and_wait_for_response`: publishes the specified payload to the given request topic and waits (till timeout) for a message to the response topic. The payload of the first message that arrives in the response topic will be returned. If the timeout expires before, an empty string ("") is returned.
  - `publish_and_wait_for_property`: publishes the specified payload to the given request topic and waits (till timeout) until the given property value is found in an incoming message to the response topic. The `path` describes the property location within the response message, the `value` the property value to look for.

    _Example:_

    ``` JSON
    {
        "status": "success",
        "result": {
            "responsecode": 10
        }
    }
    ```

    If the `responsecode` property should be checked for the value `10`, the path would be `["result", "responsecode"]`, property value would be `10`. When the requested value has been found in a response message, the payload of that message will be returned. If the timeout expires before receiving a matching message, an empty string ("") is returned.

  This class can be initialized with a given port. If no port is specified, the environment variable `MQTT_PORT` will be checked. If this is not possible either, the default value of `1883` will be used. **It's recommended to specify no port when initializing that class as it will locally use the default port `1883` and in CI the port is set by the environment variable `MQTT_PORT`. This will prevent a check-in in the wrong port during local development.**

- `IntTestHelper`: this class provides functionality to interact with the _KUKSA Data Broker_.

  - `register_datapoint`: registers a new data point with given name and type ([here](/docs/concepts/development_model/vehicle_app_sdk/#typed-datapoint-classes) you can find more information about the available types)
  - `set_..._datapoint`: set the given value for the data point with the given name (with given type). If the data point does not exist, it will be registered.

  This class can be initialized with a given port. If no port is specified, the environment variable `VDB_PORT` will be checked. If this is not possible either, the default value of `55555` will be used. **It's recommended to specify no port when initializing that class as it will locally use the default port `55555` and in CI the port is set by the environment variable `VDB_PORT`. This will prevent a check-in in the wrong port during local development.**

## Runtime components

To be able to test the _Vehicle App_ in an integrated way, the following components should be running:

- Mosquitto
- Data Broker
- Vehicle Services

We distinguish between two environments for executing the _Vehicle App_ and the runtime components:

- [**Local execution:**](/docs/tutorials/vehicle_app_runtime/local_runtime/) components are running locally in the development environment
- [**Kanto execution:**](/docs/tutorials/vehicle_app_runtime/kanto_runtime/) components (and application) are deployed and running in a Kanto control plane

### Local execution

First, make sure that the runtime services are configured and running like described [here](/docs/tutorials/vehicle_app_runtime/local_runtime).

The application itself can be executed by using a Visual Studio Launch Config (by pressing <kbd>F5</kbd>) or by executing the provided task `Local Runtime - Run VehicleApp`.

When the runtime services and the application are running, integration tests can be executed locally via

```bash
  pytest ./app/tests/integration
```

or using the testing tab in the sidebar to the left.

### Kanto runtime

First, make sure that the runtime and the services are up and running, like described [here](/docs/tutorials/vehicle_app_runtime/kanto_runtime).

The application itself can be deployed by executing the provided task `Kanto Runtime - Deploy VehicleApp` or `Kanto Runtime - Deploy VehicleApp (without rebuild)`. Depending on whether your app is already available as a container or not.

When the runtime services and the application are running, integration tests can be executed locally via

```bash
  pytest ./app/tests/integration
```

or using the testing tab in the sidebar to the left.

## Integration Tests in CI pipeline

The tests will be discovered and executed automatically in the provided [CI pipeline](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.github/workflows/ci.yml). The job `Run Integration Tests` contains all steps to set up and execute all integration tests in Kanto mode. Basically it is doing the same steps as you saw above:

1. start the Kanto runtime
1. deploy the _Vehicle App_ container
1. set the correct MQTT and Databroker ports
1. execute the integration tests

Finally the test results are collected and published as artifacts of the workflow.

## Troubleshooting

### Troubleshoot IntTestHelper

- Make sure that the _KUKSA Data Broker_ is up and running by checking the task log.
- Make sure that you are using the right ports for local execution.
- Make sure that you installed the correct version of the SDK (_SDV_-package).

### Troubleshoot Mosquitto (MQTT Broker)

- Make sure that _Mosquitto_ is up and running by checking the task log.
- Make sure that you are using the right ports.
- Use VsMqtt extension to connect to MQTT broker locally (`localhost:1883`) to monitor topics in MQTT broker by subscribing to all topics using `#`.

## Next steps

- Concept: [Deployment Model](/docs/concepts/deployment_model/)
- Concept: [Build and release process](/docs/concepts/deployment_model/vehicle_app_releases/)
