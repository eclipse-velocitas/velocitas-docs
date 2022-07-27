---
title: "Python Vehicle App Development"
date: 2022-05-09T13:43:25+05:30
weight: 3
description: >
  Learn how to develop and test the Vehicle App.
aliases:
  - /docs/tutorials/tutorial_how_to_create_a_vehicle_app.md
  - /docs/python-sdk/tutorial_how_to_create_a_vehicle_app.md
---

> We recommend that you make yourself familiar with the [Python Vehicle App SDK](/python-sdk/python_vehicle_app_sdk_overview.md) first, before going through this tutorial.

The following information describes how to develop and test the sample Vehicle App that is included in the [template repository](https://github.com/eclipse-velocitas/vehicle-app-python-template). You will learn how to use the Vehicle App SDK and how to interact with the Vehicle Model.

Once you have completed all steps, you will have a solid understanding of the development workflow and you will be able to reuse the template repository for your own Vehicle App development project.

## Develop your first Vehicle App

This section describes how to develop your first Vehicle App. Before you start building a new Vehicle App, make sure you have already read the other manuals:

- [Setup and Explore Development Enviroment](/docs/setup_and_explore_development_environment.md)
- [How to create a Vehicle Model](/docs/python-sdk/tutorial_how_to_create_a_vehicle_model.md)

Once you have established your development environment, you will be able to start developing your first Vehicle App.

For this tutorial, you will recreate the SeatAdjuster example that is included with the [template repository](https://github.com/eclipse-velocitas/vehicle-app-python-template): 
The Vehicle app allows to change the positions of the seats in the car and also provide their current positions to other applications.

A detailed explanation of the use case and the example is available [here](/docs/velocitas/docs/seat_adjuster_use_case.md).

At first, you have to create the main python script called `run.py` in `src/`. All the relevant code for new Vehicle App goes there. Afterwards, there are several steps you need to consider when developing the app:

1. Manage your imports
2. Enable logging
3. Initialize your class
4. Start the app

#### Manage your imports

Before you start development in the `run.py` you just created, it will be necessary to include the imports required, which you will understand better later through the development:

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
from sdv_model import Vehicle, vehicle  # type: ignore
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
class SeatAdjusterApp(VehicleApp):
```

In class initialization, you have to pass an instance of the Vehicle Model:

```Python
def __init__(self, vehicle_client: Vehicle):
    super().__init__()
    self.Vehicle = vehicle_client
```

We save the vehicle object to use it in our app. Now, you have initialized the app and can continue developing relevant methods.

#### Start the app

Here's an example of how to start the SeatAdjuster App we just developed:

```Python
async def main():
    """Main function"""
    logger.info("Starting seat adjuster app...")
    seat_adjuster_talent = SeatAdjusterApp(vehicle)
    await seat_adjuster_talent.run()

LOOP = asyncio.get_event_loop()
LOOP.add_signal_handler(signal.SIGTERM, LOOP.stop)
LOOP.run_until_complete(main())
LOOP.close()
```

The app is now running. In order to use it properly, we will enhance the app with more features in the next sections.

## Vehicle Model

In order to facilitate the implementation, the whole vehicle is abstracted into model classes. Please check [tutorial about creating models](/docs/python-sdk/tutorial_how_to_create_a_vehicle_model.md) for more details about this topic. In this section, the focus is on using the models.

### Import the model

The first thing you need to do to get access to the Vehicle Model. In the section about [distributing a model](/docs/python-sdk/tutorial_how_to_create_a_vehicle_model.md#distributing-your-python-vehicle-model), you got to know the different methods.

If you just want to use your model in one app, you can simply copy the classes into your `src`-folder. In this example, you find the classes inside the `vehicle_model`-folder. As you have already seen in the section about [initializing the app](/docs/getting-started/tutorials/tutorial_how_to_create_a_vehicle_app/#initialize-your-class), we need the `vehicle model`to use the app.

As you know, the model has a single [Datapoint](#datapoints) for the speed and a reference to the `cabin`-model.

Accessing the speed can be done via

```Python
vehicle_speed = await self.Vehicle.Speed.get()
```

As the `get`-method of the Datapoint-class there is a coroutine and you have to use the `await` keyword when using it.

If you want to get deeper inside the vehicle, to access a single seat for example, you just have to go the model-chain down:

```Python
self.DriverSeatPosition = await self.vehicle_client.Cabin.Seat.Row1.Pos1.Position.get()
```

## Subscription to Datapoints

If you want to get notified about changes of a specific `Datapoint`, you can subscribe to this event, e.g. as part of the "on_start"-method in your app. 

```Python

    async def on_start(self):
        """Run when the vehicle app starts"""
        await self.Vehicle.Cabin.Seat.element_at(1, 1).Position.subscribe(
            self.on_seat_position_changed
        )

    async def on_seat_position_changed(self, data):
        # handle the event here
        response_topic = "seatadjuster/currentPosition"
        seat_path = self.Vehicle.Cabin.Seat.element_at(1, 1).Position.get_path()
        response_data = {"position": data.fields[seat_path].uint32_value}

```
Every Datapoint provides a *.subscribe()* method that allows for providing a callback function which will be invoked envery datapoint update. Subscribed data is available in the respective *data.fields* value and are accessed by their complete path.

The SDK also supports annotations for subscribing to datapoint changes  with`@subscribe_data_points` defined by the whole path to the `Datapoint` of interest.

```Python
@subscribe_data_points("Vehicle.Cabin.Seat.Row1.Pos1.Position")
async def on_vehicle_seat_change(self, data):
    response_topic = "seatadjuster/currentPosition"
    response_data = {"position": data.fields["Vehicle.Cabin.Seat.Row1.Pos1.Position"].uint32_value}

    await self.publish_mqtt_event(response_topic, json.dumps(response_data))
```

Similarly, subscribed data is available in the respective *data.fields* value and are accessed by their complete path.

## Services

Services are used to communicate with other parts of the vehicle. Please read the basics about them [here]( /docs/python-sdk/tutorial_how_to_create_a_vehicle_model.md/#add-a-vehicle-service).

The following few lines show you how to use the `MoveComponent`-method of the `SeatService` you have created:

```Python
location = SeatLocation(row=1, index=1)
await self.vehicle_client.Cabin.SeatService.MoveComponent(
    location, BASE, 300
    )
```

In order to know which seat to move, you have to pass a `SeatLocation` object as the first parameter. The second argument specifies the component to be moved. The possible components are defined in the proto-files. The last parameter to be passed into the method is the final position of the component.

> Make sure to use the `await` keyword when calling service methods, since these methods are co-routines. 

### MQTT

Interaction with other Vehicle Apps or the cloud is enabled by using Mosquitto MQTT Broker. The MQTT broker runs inside a docker image, which is started automatically after starting the DevContainer.

In the [general section](/docs/getting-started/quickstart/#send-mqtt-messages-to-vehicle-app) about the Vehicle App, you already tested sending MQTT messages to the app.
In the previous sections, you generally saw how to use `Vehicle Models`, `Datapoints` and `GRPC Services`. In this section, you will learn how to combine them with MQTT.

In order to receive and process MQTT messages inside your app, simply use the `@subscribe_topic` annotations from the SDK:

```Python
    @subscribe_topic("seatadjuster/setPosition/request")
    async def on_set_position_request_received(self, data_str: str) -> None:
        data = json.loads(data_str)
        response_topic = "seatadjuster/setPosition/response"
        response_data = {"requestId": data["requestId"], "result": {}}
        
        # ...
```
The `on_set_position_request_received` method will now be invoked every time a message is created on the subscribed topic `"seatadjuster/setPosition/response"`. The message data (string) is provided as parameter. In the example above the data is parsed to json (`data = json.loads(data_str)`).

In order to publish data to other subscribers, the SDK provides the appropriate convenience method: `self.publish_mqtt_event()`

```Python
    async def on_seat_position_changed(self, data):
        response_topic = "seatadjuster/currentPosition"
        seat_path = self.Vehicle.Cabin.Seat.element_at(1, 1).Position.get_path()
        await self.publish_mqtt_event(
            response_topic,
            json.dumps({"position": data.fields[seat_path].uint32_value}),
        )
```
The above example illustrates how one can easily publish messages. In this case, every time the seat position changes, the new position is published to `seatadjuster/currentPosition`

## UnitTests

Unit testing is an important part of the development, so let's have a look at how to do that. You can find some example tests in `test/integration_test.py`.
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

Looking at a test you notice the annotation `@pytest.mark.asyncio`. This is required if the test is defined as a co-routine. The next step is to create a mock from all the external dependencies. The method takes 4 arguments: first is the object to be mocked, second the method for which you want to modify the return value, third a callable and the last argument is the return value.
After creating the mock, you can test the method and check the response. Use asserts to make your test fail if the response does not match.

## See the results

Once the implementation is done, it is time to run and debug the app.

### Run your App

If you want to run the app together with a Dapr sidecar and use the Dapr middleware, you have to use the "dapr run ..." command to start your app:

```bash
dapr run --app-id seatadjuster --app-protocol grpc --app-port 50008 --config ./.dapr/config.yaml --components-path ./.dapr/components  python3 ./src/run.py
```

You already have seen this command and how to check if it is working in the [general setup](/docs/getting-started/quickstart/#start-and-test-vehicle-app).

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

If you want to know more about dapr and the configuration, please visit https://dapr.io

### Debug your Vehicle App

In the [introduction about debugging](/docs/getting-started/quickstart/#debug-vehicle-app), you saw how to start a debugging session. In this section, you will learn what is happening in the background.

In order to be able to debug your code, you need to add some configs in Visual Studio Code. You find the files in the `.vscode` folder. The main entrypoint is the launch.json. All configurations are stored here.
Currently there is only one for the SeatAdjuster App.

```JSON
"configurations": [
    {
        "type": "python",
        "justMyCode": false,
        "request": "launch",
        "name": "SeatAdjuster",
        "program": "${workspaceFolder}/src/run.py",
        "console": "integratedTerminal",
        "preLaunchTask": "dapr-SeatAdjuster-run",
        "postDebugTask": "dapr-SeatAdjuster-stop",
        "env": {
            "DAPR_GRPC_PORT":"50001",
            "SEATSERVICE_DAPR_APP_ID": "seatservice",
            "VEHICLEDATABROKER_DAPR_APP_ID": "vehicledatabroker"
        }
    }
]
```

We specify which python-script to run using the `program` key. With the `preLaunchTask` and `postDebugTask` keys, you can also specify tasks to run before or after debugging. In this example, DAPR is set up to start the app before and stop it again after debugging. Below you can see the 2 tasks.

```JSON
{
    "label": "dapr-SeatAdjuster-run",
    "appId": "seatadjuster",
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
    "label": "dapr-SeatAdjuster-stop",
    "type": "shell",
    "command": [
        "dapr stop --app-id seatadjuster"
    ],
    "presentation": {
        "close": true,
        "reveal": "never"
    },
}
```

Lastly, the environment variables can also be specified.

You can adapt the JSON to your needs (e.g., change the ports, add new tasks) or even add a completely new configuration for another Vehicle App.

Once you are done, you have to switch to the debugging tab (sidebar on the left) and select your configuration using the dropdown on the top. You can now start the debug session by clicking the play button or <kbd>F5</kbd>. Debugging is now as simple as in every other IDE, just place your breakpoints and follow the flow of your Vehicle App.

## Next steps
- Concept: [Python SDK Overview](/docs/concepts/python_vehicle_app_sdk_overview.md)
- Tutorial: [Deploy runtime services in Kubernetes mode](/docs/tutorials/run_runtime_services_kubernetes.md)
- Tutorial: [Start runtime services locally](/docs/tutorials/run_runtime_services_locally.md)
- Tutorial: [Creating a Python Vehicle Model](/docs/tutorials/tutorial_how_to_create_a_vehicle_model.md)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/integration_tests.md)
- Concept: [Deployment Model](/docs/concepts/deployment-model.md)
- Tutorial: [Deploy a Python Vehicle App with Helm](/docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md)
