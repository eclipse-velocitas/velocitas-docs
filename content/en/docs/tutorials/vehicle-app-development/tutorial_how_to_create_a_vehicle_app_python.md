---
title: "Python Vehicle App Development"
date: 2022-05-09T13:43:25+05:30
weight: 1
description: >
  Learn how to develop and test the Vehicle App using Python.
aliases:
  - /docs/tutorials/python/tutorial_how_to_create_a_vehicle_app_python.md
---

> We recommend that you make yourself familiar with the [Vehicle App SDK](/docs/concepts/vehicle_app_sdk_overview.md) first, before going through this tutorial.

The following information describes how to develop and test the sample Vehicle App that is included in the [template repository](https://github.com/eclipse-velocitas/vehicle-app-python-template). You will learn how to use the Vehicle App SDK and how to interact with the Vehicle Model.

Once you have completed all steps, you will have a solid understanding of the development workflow and you will be able to reuse the template repository for your own Vehicle App development project.

## Develop your first Vehicle App

This section describes how to develop your first Vehicle App. Before you start building a new Vehicle App, make sure you have already read this manual:

- [Setup and Explore Development Enviroment](/docs/setup_and_explore_development_environment.md)

Once you have established your development environment, you will be able to start developing your first Vehicle App.

For this tutorial, you will recreate the Vehicle App that is included with the [SDK repository](https://github.com/eclipse-velocitas/vehicle-app-python-sdk/tree/main/examples/seat-adjuster):
The Vehicle App allows to change the positions of the seats in the car and also provide their current positions to other applications.

A detailed explanation of the use case and the example is available [here](/docs/velocitas/docs/seat_adjuster_use_case.md).

At first, you have to create the main python script called `main.py` in `/app/src`. All the relevant code for new Vehicle App goes there. Afterwards, there are several steps you need to consider when developing the app:

1. Manage your imports
2. Enable logging
3. Initialize your class
4. Start the app

#### Manage your imports

Before you start development in the `main.py` you just created, it will be necessary to include the imports required, which you will understand better later through the development:

```Python
import asyncio
import json
import logging
import signal

import grpc
from sdv.util.log import (  # type: ignore
    get_opentelemetry_log_factory,
    get_opentelemetry_log_format,
)
from sdv.vehicle_app import VehicleApp, subscribe_topic
from vehicle import Vehicle, vehicle  # type: ignore
from sdv_model.proto.seats_pb2 import BASE, SeatLocation  # type: ignore
```

#### Enable logging

The following logging configuration applies the default log format provided by the SDK and sets the log level to INFO:

```Python
logging.setLogRecordFactory(get_opentelemetry_log_factory())
logging.basicConfig(format=get_opentelemetry_log_format())
logging.getLogger().setLevel("INFO")
logger = logging.getLogger(__name__)
```

#### Initialize your class

The main class of your new Vehicle App needs to inherit the `VehicleApp` provided by the [SDK](https://github.com/eclipse-velocitas/vehicle-app-python-sdk).

```Python
class MyVehicleApp(VehicleApp):
```

In class initialization, you have to pass an instance of the Vehicle Model:

```Python
def __init__(self, vehicle_client: Vehicle):
    super().__init__()
    self.Vehicle = vehicle_client
```

We save the vehicle object to use it in our app. Now, you have initialized the app and can continue developing relevant methods.

#### Start the app

Here's an example of how to start the MyVehicleApp App that we just developed:

```Python
async def main():
    """Main function"""
    logger.info("Starting my VehicleApp...")
    vehicle_app = MyVehicleApp(vehicle)
    await vehicle_app.run()

LOOP = asyncio.get_event_loop()
LOOP.add_signal_handler(signal.SIGTERM, LOOP.stop)
LOOP.run_until_complete(main())
LOOP.close()
```

The app is now running. In order to use it properly, we will enhance the app with more features in the next sections.

## Vehicle Model Access

In order to facilitate the implementation, the whole vehicle is abstracted into model classes. Please check [tutorial about creating models](/docs/tutorials/vehicle_model_creation/) for more details about this topic. In this section, the focus is on using the models.

The first thing you need to do to get access to the Vehicle Model. If you derived your project repository from our template, we already provide a generated model installed as a Python package named `vehicle`. So, most probably you need nothing to do. How to tailor the model to your needs or how you could get access to vehicle services is described in the tutorial linked above.

If you want to access a single [Datapoint](/docs/concepts/development_model/vehicle_app_sdk/#datapoint) for the vehicle speed, this can be done via

```Python
vehicle_speed = await self.Vehicle.Speed.get()
```

As the `get`-method of the Datapoint-class there is a coroutine you have to use the `await` keyword when using it.

If you want to get deeper inside the vehicle, to access a single seat for example, you just have to go the model-chain down:

```Python
self.DriverSeatPosition = await self.vehicle_client.Cabin.Seat.Row1.Pos1.Position.get()
```

## Subscription to Datapoints

If you want to get notified about changes of a specific `Datapoint`, you can subscribe to this event, e.g. as part of the `on_start`-method in your app.

```Python
    async def on_start(self):
        """Run when the vehicle app starts"""
        await self.Vehicle.Cabin.Seat.Row(1).Pos(1).Position.subscribe(
            self.on_seat_position_changed
        )
```

Every Datapoint provides a *.subscribe()* method that allows for providing a callback function which will be invoked on every datapoint update. Subscribed data is available in the respective *DataPointReply* object and need to be accessed via the reference to the subscribed datapoint. The returned object is of type `TypedDataPointResult` which holds the `value` of the data point
and the `timestamp` at which the value was captured by the data broker.
Therefore the `on_seat_position_changed` callback function needs to be implemented like this:

```Python
    async def on_seat_position_changed(self, data: DataPointReply):
        # handle the event here
        response_topic = "seatadjuster/currentPosition"
        position = data.get(self.Vehicle.Cabin.Seat.Row(1).Pos(1).Position).value
        # ...
```

{{% alert title="Note" %}}
The SDK also supports annotations for subscribing to datapoint changes with `@subscribe_data_points` defined by the whole path to the `Datapoint` of interest.

```Python
@subscribe_data_points("Vehicle.Cabin.Seat.Row1.Pos1.Position")
async def on_vehicle_seat_change(self, data: DataPointReply):
    response_topic = "seatadjuster/currentPosition"
    response_data = {"position": data.get(self.Vehicle.Cabin.Seat.Row1.Pos1.Position).value}

    await self.publish_mqtt_event(response_topic, json.dumps(response_data))
```

Similarly, subscribed data is available in the respective *DataPointReply* object and needs to be accessed via the reference to the subscribed datapoint.
{{% /alert %}}

## Services

{{% alert title="Note" %}}Services are not supported by our [automated vehicle model lifecycle](/docs/tutorials/vehicle_model_creation/automated_model_lifecycle) for the time being. If you need access to services please read [here](/docs/tutorials/vehicle_model_creation/manual_model_creation/#add-a-vehicle-service") how to achieve that.{{% /alert %}}

Services are used to communicate with other parts of the vehicle. Please read the basics about them [here](/docs/tutorials/vehicle_model_creation/manual_model_creation/manual_creation_python/#add-a-vehicle-service).

The following lines show you how to use the `MoveComponent`-method of the `SeatService` from the vehicle model:

```Python
location = SeatLocation(row=1, index=1)
await self.vehicle_client.Cabin.SeatService.MoveComponent(
    location, BASE, data["position"]
    )
```

In order to know which seat to move, you have to pass a `SeatLocation` object as the first parameter. The second argument specifies the component to be moved. The possible components are defined in the proto-files. The last parameter to be passed into the method is the final position of the component.

> Make sure to use the `await` keyword when calling service methods, since these methods are coroutines.

### MQTT

Interaction with other Vehicle Apps or the cloud is enabled by using Mosquitto MQTT Broker. The MQTT broker runs inside a docker image, which is started automatically after starting the DevContainer.

In the [quickstart section](/docs/tutorials/quickstart/#debugging-vehicle-app) about the Vehicle App, you already tested sending MQTT messages to the app.
In the previous sections, you generally saw how to use `Vehicle Models`, `Datapoints` and `GRPC Services`. In this section, you will learn how to combine them with MQTT.

In order to receive and process MQTT messages inside your app, simply use the `@subscribe_topic` annotations from the SDK for an additional method `on_set_position_request_received` you have to implement:

```Python
    @subscribe_topic("seatadjuster/setPosition/request")
    async def on_set_position_request_received(self, data_str: str) -> None:
        data = json.loads(data_str)
        response_topic = "seatadjuster/setPosition/response"
        response_data = {"requestId": data["requestId"], "result": {}}
        
        # ...
```

The `on_set_position_request_received` method will now be invoked every time a message is published to the subscribed topic `"seatadjuster/setPosition/response"`. The message data (string) is provided as parameter. In the example above the data is parsed to json (`data = json.loads(data_str)`).

In order to publish data to topics, the SDK provides the appropriate convenience method: `self.publish_mqtt_event()` which will be added to the `on_seat_position_changed` callback function from before.

```Python
    async def on_seat_position_changed(self, data: DataPointReply):
        response_topic = "seatadjuster/currentPosition"
        position = data.get(self.Vehicle.Cabin.Seat.Row(1).Pos(1).Position).value
        await self.publish_mqtt_event(
            response_topic,
            json.dumps({"position": position}),
        )
```

The above example illustrates how one can easily publish messages. In this case, every time the seat position changes, the new position is published to `seatadjuster/currentPosition`

Your `main.py` should now have a full implementation for `class MyVehicleApp(VehicleApp):` containing:

- `__init__()`
- `on_start()`
- `on_seat_position_changed()`
- `on_set_position_request_received()`

and last but not least a `main()`-method to run the app.

Check the [`seat-adjuster`](https://github.com/eclipse-velocitas/vehicle-app-python-sdk/tree/main/examples/seat-adjuster) example to see a more detailed implementation including error handling.

## UnitTests

Unit testing is an important part of the development, so let's have a look at how to do that. You can find some example tests in `/app/tests/unit`.
First, you have to import the relevant packages for unit testing and everything you need for your implementation:

```Python
from unittest import mock

import pytest
from sdv.vehicle_app import VehicleApp
from sdv_model.Cabin.SeatService import SeatService  # type: ignore
from sdv_model.proto.seats_pb2 import BASE, SeatLocation  # type: ignore
```

```Python
@pytest.mark.asyncio
async def test_for_publish_to_topic():
    # Disable no-value-for-parameter, seems to be false positive with mock lib
    # pylint: disable=no-value-for-parameter

    with mock.patch.object(
        VehicleApp, "publish_mqtt_event", new_callable=mock.AsyncMock, return_value=-1
    ):
        response = await VehicleApp.publish_mqtt_event(
            str("sampleTopic"), get_sample_request_data()  # type: ignore
        )
        assert response == -1


def get_sample_request_data():
    return {"position": 330, "requestId": "123456789"}
```

Looking at a test you notice the annotation `@pytest.mark.asyncio`. This is required if the test is defined as a coroutine. The next step is to create a mock from all the external dependencies. The method takes 4 arguments: first is the object to be mocked, second the method for which you want to modify the return value, third a callable and the last argument is the return value.
After creating the mock, you can test the method and check the response. Use asserts to make your test fail if the response does not match.

## See the results

Once the implementation is done, it is time to run and debug the app.

### Run your App

In order to run the app make sure you have the `seatservice` configured as a dependency in your [`./AppManifest.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/app/AppManifest.json). Read more about it in the [run runtime services](/docs/run_runtime_services_locally.md) section.

If you want to run the app together with a Dapr sidecar and use the Dapr middleware, you have to use the "dapr run ..." command to start your app:

```bash
dapr run --app-id seatadjuster --app-protocol grpc --app-port 50008 --config ./.dapr/config.yaml --components-path ./.dapr/components  python3 ./app/src/main.py
```

You already have seen this command and how to check if it is working in the [general setup](/docs/tutorials/vehicle-app-development/tutorial_how_to_create_a_vehicle_app_python/#debug-your-vehicle-app).

2 parameters may be unclear in this command:

- the config file `config.yaml`
- the components-path

For now, you just need to know that these parameters are needed to make everything work together.

The config.yaml has to be placed in the folder called `.dapr`and has the following content:

```Yaml
apiVersion: dapr.io/v1alpha1
kind: Configuration
metadata:
 name: config
spec:
 tracing:
   samplingRate: "1"
   zipkin:
     endpointAddress: http://localhost:9411/api/v2/spans
 features:
   - name: proxy.grpc
     enabled: true
```

An important part is the enabling of the GRPC proxy, to make the communication work.

Inside the `.dapr` folder you find another folder called `components`. There you only find one configuration file for the MQTT communication with the following content:

```Yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: mqtt-pubsub
  namespace: default
spec:
  type: pubsub.mqtt
  version: v1
  metadata:
  - name: url
    value: "mqtt://localhost:1883"
  - name: qos
    value: 1
  - name: retain
    value: "false"
  - name: cleanSession
    value: "false"
```

If you want to know more about dapr and the configuration, please visit <https://dapr.io>

### Debug your Vehicle App

In the [introduction about debugging](/docs/tutorials/quickstart/#debugging-vehicle-app), you saw how to start a debugging session. In this section, you will learn what is happening in the background.

The debug session launch settings are already prepared for the `VehicleApp` in `/.vscode/launch.json`.

```JSON
"configurations": [
    {
        "type": "python",
        "justMyCode": false,
        "request": "launch",
        "name": "VehicleApp",
        "program": "${workspaceFolder}/app/src/main.py",
        "console": "integratedTerminal",
        "preLaunchTask": "dapr-VehicleApp-run",
        "postDebugTask": "dapr-VehicleApp-stop",
        "env": {
            "DAPR_HTTP_PORT": "3500",
            "DAPR_GRPC_PORT": "${input:DAPR_GRPC_PORT}",
            "SERVICE_DAPR_APP_ID": "${input:SERVICE_NAME}",
            "VEHICLEDATABROKER_DAPR_APP_ID": "vehicledatabroker"
        }
    }
]
```

We specify which python-script to run using the `program` key. With the `preLaunchTask` and `postDebugTask` keys, you can also specify tasks to run before or after debugging. In this example, DAPR is set up to start the app before and stop it again after debugging. Below you can see the 2 tasks to find in `/.vscode/tasks.json`.

```JSON
{
    "label": "dapr-VehicleApp-run",
    "appId": "vehicleapp",
    "appPort": 50008,
    "componentsPath": "./.dapr/components",
    "config": "./.dapr/config.yaml",
    "appProtocol": "grpc",
    "type": "dapr",
    "args": [
        "--dapr-grpc-port",
        "50001",
        "--dapr-http-port",
        "3500"
    ],
}
```

```JSON
{
    "label": "dapr-VehicleApp-stop",
    "type": "shell",
    "command": [
        "dapr stop --app-id vehicleapp"
    ],
    "presentation": {
        "close": true,
        "reveal": "never"
    },
}
```

Lastly, the environment variables can also be specified.

You can adapt the configuration in `/.vscode/launch.json` to your needs (e.g., change the ports, add new tasks) or even add a completely new configuration for another Vehicle App.

Environment Variables can also be configured on the central [`/app/AppManifest.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/app/AppManifest.json) and read out by the launch configuration in Visual Studio Code through a preinstalled extension in the devcontainer [Tasks Shell Input](https://marketplace.visualstudio.com/items?itemName=augustocdias.tasks-shell-input).

```JSON
"inputs": [
    {
        "id": "DAPR_GRPC_PORT",
        "type": "command",
        "command": "shellCommand.execute",
        "args": {
            "useSingleResult": true,
            "command": "cat ./app/AppManifest.json | jq .[].DAPR_GRPC_PORT | tr -d '\"'",
            "cwd": "${workspaceFolder}",
        }
    },
    {
        "id": "SERVICE_NAME",
        "type": "command",
        "command": "shellCommand.execute",
        "args": {
            "useSingleResult": true,
            "command": "cat ./app/AppManifest.json | jq .[].Name | tr -d '\"'",
            "cwd": "${workspaceFolder}",
        }
    }
]
```

Once you are done, you have to switch to the debugging tab (sidebar on the left) and select your configuration using the dropdown on the top. You can now start the debug session by clicking the play button or <kbd>F5</kbd>. Debugging is now as simple as in every other IDE, just place your breakpoints and follow the flow of your Vehicle App.

## Next steps

- Concept: [SDK Overview](/docs/concepts/development_model/vehicle_app_sdk)
- Tutorial: [Deploy runtime services in Kubernetes](/docs/tutorials/run_runtime_services_kubernetes.md)
- Tutorial: [Start runtime services locally](/docs/tutorials/run_runtime_services_locally.md)
- Tutorial: [Creating a Python Vehicle Model](/docs/tutorials/vehicle_model_creation.md)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/integration_tests.md)
- Concept: [Deployment Model](/docs/concepts/deployment_model/)
- Tutorial: [Deploy a Python Vehicle App with Helm](/docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md)
