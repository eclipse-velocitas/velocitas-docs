---
title: "Vehicle App Integration Testing"
date: 2022-05-09T13:46:21+05:30
weight: 60
description: >
  Learn how to test that a Vehicle App together with the KUKSA Data Broker and potentially other dependant Vehicle Services or Vehicle Apps runs as expected.
aliases:
  - /docs/tutorials/integration_tests.md
  - /docs/integration_tests.md
---

To be sure that a newly created _Vehicle App_ will run together with the _KUKSA Data Broker_ and potentially other dependant _Vehicle Services_ or _Vehicle Apps_, it's essential to write integration tests along with developing the app.

To execute an integration test, the dependant components need to be running and accessible from the test runner. This guide will describe how integration tests can be written and integrated in the CI pipeline so that they are executed automatically when building the application.

## Writing Test Cases

To write an integration test, you should check the sample that comes with the template ([`/app/tests/integration/integration_test.py`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/app/tests/integration/integration_test.py)). To support interacting with the MQTT broker and the KUKSA Data Broker (to get and set values for DataPoints), there are two classes present in Python SDK that will help:

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

    If the `responsecode` property should be checked for the value `10`, the path would be `["result", "responsecode]`, property value would be `10`. When the requested value has been found in a response message, the payload of that message will be returned. If the timeout expires before receiving a matching message, an empty string ("") is returned.

  This class can be initialized with a given port. If no port is specified, the environment variable `MQTT_PORT` will be checked. If this is not possible either, the default value of `1883` will be used. **It's recommended to specify no port when initializing that class as it will locally use the default port `1883` and in CI the port set by the environment variable `MQTT_PORT`. This will prevent a check-in in the wrong port from local development.**

- `IntTestHelper`: this class provides functionality to interact with the _KUKSA Data Broker_.

  - `register_datapoint`: registers a new datapoint with given name and type
  - `set_..._datapoint`: set the given value for the datapoint with the given name (with given type). If the datapoint does not exist, it will be registered.

  This class can be initialized with a given port. If no port is specified, the environment variable `VDB_PORT` will be checked. If this is not possible either, the default value of `55555` will be used. **It's recommended to specify no port when initializing that class as it will locally use the default port `55555` and in CI the port set by the environment variable `VDB_PORT` which is set. This will prevent a check-in in the wrong port from local development.**

> **Please make sure that you don't check in the test classes with using local ports because then the execution in the CI workflow will fail (as the CI workflow uses Kubernetes execution for running integration tests).**

## Runtime components

To be able to test the _Vehicle App_ in an integrated way, the following components should be running:

- Dapr
- Mosquitto
- Data Broker
- Vehicle Services

We distinguish between two environments for executing the _Vehicle App_ and the runtime components:

- **Local execution:** components are running locally in the development environment
- **Kubernetes execution:** components (and application) are deployed and running in a Kubernetes control plane (e.g., K3D)

### Local Execution

First, make sure that the runtime services are configured and running like described [here](/docs/run_runtime_services_locally.md).

The application itself can be executed by using a Visual Studio Launch Config (by pressing <kbd>F5</kbd>) or by executing `VehicleApp` using provided task.

When the runtime services and the application are running, integration tests can be executed locally.

### Kubernetes execution (K3D)

If you want to execute the integration tests in Kubernetes mode, make sure that K3D is up and running according to the [documentation](/docs/run_runtime_services_kubernetes.md). Local ports for _Mosquitto_ and _KUKSA Data Broker_ are `1883`/`55555`. In Kubernetes mode, the ports would be the locally exposed ports `31883`/`30555`, to ensure that the tests connect to the containers, please execute the following commands in new bash terminal:

```bash
  export MQTT_PORT=31883 && export VDB_PORT=30555 && pytest
```

## Integration Tests in CI pipeline

The tests will be discovered and executed automatically in the [CI pipeline](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.github/workflows/ci.yml). The job `Run Integration Tests` contains all steps to set up and execute tests in Kubernetes mode. The results are published as test results to the workflow.

# Troubleshooting

## Check if the services are registered correctly in Dapr

- Dapr extension is available as VS Code extension and gives overview of all running Dapr services.

## Troubleshoot IntTestHelper

- Make sure that the _KUKSA Data Broker_ is up and running by checking the task log.
- Make sure that you are using the right ports for local/Kubernetes execution.
- Make sure that you installed the correct version of the SDK (_SDV_-package).

## Troubleshoot Mosquitto (MQTT Broker)

- Make sure that the _Mosquitto_ up and running by checking the task log.
- Make sure that you are using the right ports for local/Kubernetes execution.
- Use VsMqtt extension to connect to MQTT broker (`localhost:1883` (local) or `localhost:31883` (Kubernetes)) to monitor topics in MQTT broker.

## Next steps

- Concept: [Deployment Model](/docs/concepts/deployment_model/)
- Concept: [Build and release process](/docs/concepts/deployment_model/vehicle_app_releases/)
- Tutorial: [Deploy a Python Vehicle App with Helm](/docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md)
