---
title: "Python Vehicle App Development"
date: 2022-05-09T13:43:25+05:30
weight: 1
description: >
  Learn how to develop and test a _Vehicle App_ using Python.
aliases:
  - /docs/tutorials/vehicle_app_development/python_development.md
---

> We recommend that you make yourself familiar with the [_Vehicle App_ SDK](/docs/concepts/development_model/vehicle_app_sdk.md) first, before going through this tutorial.

The following information describes how to develop and test the sample _Vehicle App_ that is included in the [Python template repository](https://github.com/eclipse-velocitas/vehicle-app-python-template). You will learn how to use the _Vehicle App_ Python SDK and how to interact with the Vehicle Model.

Once you have completed all steps, you will have a solid understanding of the development workflow and you will be able to reuse the template repository for your own _Vehicle App_ development project.

## Develop your first _Vehicle App_

This section describes how to develop your first _Vehicle App_. Before you start building a new _Vehicle App_, make sure you have already read this manual:

- [Quickstart](/docs/tutorials/quickstart.md)

Once you have established your development environment, you will be able to start developing your first _Vehicle App_.

For this tutorial, you will recreate the _Vehicle App_ that is included with the [SDK repository](https://github.com/eclipse-velocitas/vehicle-app-python-sdk/tree/main/examples/seat-adjuster):
The _Vehicle App_ allows to change the position of the driver's seat in the car and also provides its current positions to other applications.
A detailed explanation of the use case and the example is available [here](/docs/about/use_cases/seat_adjuster.md).

{{% alert title="Note" %}}
If you don't like to do the following steps by yourself, you can use the `Import example app from SDK` task within VS Code to get a working copy of this example into your repository.
<br>
(For details about the import of an example from the SDK look [here](/docs/tutorials/quickstart/import_examples).)
{{% /alert %}}

## Setting up the basic skeleton of your app

At first, you have to create the main Python script called `main.py` in `/app/src`. All the relevant code for your new _Vehicle App_ goes there.

If you've created your app development repository from our [Python template repository](https://github.com/eclipse-velocitas/vehicle-app-python-template), the [Velocitas CLI create command](/docs/concepts/lifecycle_management/velocitas_cli/#velocitas-create) or via [digital.auto prototyping](/docs/tutorials/prototyping/digital_auto) a file with this name is already present and can be adjusted to your needs.

Setting up the basic skeleton of an app consists of the following steps:

1. [Manage your imports](#manage-your-imports)
2. [Enable logging](#enable-logging)
3. [Initialize your class](#initialize-your-class)
4. [Define the entry point of your app](#entry-point-of-your-app)

### Manage your imports

Before you start development in the `main.py` you just created, it will be necessary to include the imports required, which you will understand better later through the development:

```Python
import asyncio
import json
import logging
import signal

from sdv.util.log import (  # type: ignore
    get_opentelemetry_log_factory,
    get_opentelemetry_log_format,
)
from sdv.vdb.reply import DataPointReply
from sdv.vehicle_app import VehicleApp, subscribe_topic
from vehicle import Vehicle, vehicle  # type: ignore
```

### Enable logging

The following logging configuration applies the default log format provided by the SDK and sets the log level to INFO:

```Python
logging.setLogRecordFactory(get_opentelemetry_log_factory())
logging.basicConfig(format=get_opentelemetry_log_format())
logging.getLogger().setLevel("INFO")
logger = logging.getLogger(__name__)
```

### Initialize your class

The main class of your new _Vehicle App_ needs to inherit the `VehicleApp` provided by the [Python SDK](https://github.com/eclipse-velocitas/vehicle-app-python-sdk).

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

### Entry point of your app

Here's an example of an entry point to the MyVehicleApp that we just developed:

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

With this your app can now be started. In order to provide some meaningful behaviour of the app, we will enhance it with more features in the next sections.

## Vehicle Model Access

In order to facilitate the implementation, the whole vehicle is abstracted into model classes. Please check [tutorial about creating models](/docs/tutorials/vehicle_model_creation) for more details about this topic. In this section, the focus is on using the model.

The first thing you need to do is to get access to the Vehicle Model. If you derived your project repository from our template, we already provide a generated model installed as a Python package named `vehicle`. Hence, in most cases no additional setup is necessary. How to tailor the model to your needs or how you could get access to vehicle services is described in the tutorial linked above.

If you want to access a single [DataPoint](/docs/concepts/development_model/vehicle_app_sdk/#datapoint) e.g. for the vehicle speed, this can be done via

```Python
vehicle_speed = await self.Vehicle.Speed.get()
```

As the `get()` method of the DataPoint-class there is a coroutine you have to use the `await` keyword when using it.

If you want to get deeper inside the vehicle, to access a single seat for example, you just have to go the model-chain down:

```Python
self.DriverSeatPosition = await self.vehicle_client.Cabin.Seat.Row1.Pos1.Position.get()
```

## Subscription to Data Points

If you want to get notified about changes of a specific `DataPoint`, you can subscribe to this event, e.g. as part of the `on_start()` method in your app.

```Python
    async def on_start(self):
        """Run when the vehicle app starts"""
        await self.Vehicle.Cabin.Seat.Row1.Pos1.Position.subscribe(
            self.on_seat_position_changed
        )
```

Every `DataPoint` provides a _.subscribe()_ method that allows for providing a callback function which will be invoked on every data point update. Subscribed data is available in the respective _DataPointReply_ object and need to be accessed via the reference to the subscribed data point. The returned object is of type `TypedDataPointResult` which holds the `value` of the data point
and the `timestamp` at which the value was captured by the data broker.
Therefore the `on_seat_position_changed` callback function needs to be implemented like this:

```Python
    async def on_seat_position_changed(self, data: DataPointReply):
        # handle the event here
        response_topic = "seatadjuster/currentPosition"
        position = data.get(self.Vehicle.Cabin.Seat.Row1.Pos1.Position).value
        # ...
```

## Subscription using Annotations

The Python SDK also supports annotations for subscribing to data point changes with `@subscribe_data_points` defined by the whole path to the `DataPoint` of interest.

```Python
@subscribe_data_points("Vehicle.Cabin.Seat.Row1.Pos1.Position")
async def on_vehicle_seat_change(self, data: DataPointReply):
    response_topic = "seatadjuster/currentPosition"
    response_data = {"position": data.get(self.Vehicle.Cabin.Seat.Row1.Pos1.Position).value}

    await self.publish_mqtt_event(response_topic, json.dumps(response_data))
```

Similarly, subscribed data is available in the respective _DataPointReply_ object and needs to be accessed via the reference to the subscribed data point.

## Services

Services are used to communicate with other parts of the vehicle via remote function calls (RPC). Please read the basics about them [here](/docs/tutorials/vehicle_model_creation/manual_model_creation/manual_creation_python/#add-a-vehicle-service).

{{% alert title="Note" %}}
Services are not supported by our [automated vehicle model lifecycle](/docs/tutorials/vehicle_model_creation/automated_model_lifecycle) for the time being. If you need access to services please read [here](/docs/tutorials/vehicle_model_creation/manual_model_creation) how you can create a model and add services to it manually.
{{% /alert %}}

The following code snippet shows how to use the `MoveComponent()` method of the `SeatService` from the vehicle model:

```Python
location = SeatLocation(row=1, index=1)
await self.vehicle_client.Cabin.SeatService.MoveComponent(
    location, BASE, data["position"]
    )
```

In order to define which seat you like to move, you have to pass a `SeatLocation` object as the first parameter. The second argument specifies the component of the seat to be moved. The possible components are defined in the proto files. The last parameter to be passed into the method is the desired position of the component.

> Make sure to use the `await` keyword when calling service methods, since these methods are asynchronously working coroutines.

### MQTT

Interaction with other _Vehicle Apps_ or with the cloud is enabled by using the Mosquitto MQTT Broker. The MQTT broker runs inside a docker container, which is started as part of one of our [predefined runtimes](../../vehicle_app_runtime/).

In the [quickstart section](/docs/tutorials/quickstart/#how-to-debug-_vehicle-app_) about the _Vehicle App_, you already tested sending MQTT messages to the app.
In the previous sections, you generally saw how to use `Vehicle Models`, `DataPoints` and `Services`. In this section, you will learn how to combine them with MQTT.

In order to receive and process MQTT messages inside your app, simply use the `@subscribe_topic` annotations from the SDK for an additional method `on_set_position_request_received()` you have to implement:

```Python
    @subscribe_topic("seatadjuster/setPosition/request")
    async def on_set_position_request_received(self, data_str: str) -> None:
        data = json.loads(data_str)
        response_topic = "seatadjuster/setPosition/response"
        response_data = {"requestId": data["requestId"], "result": {}}

        # ...
```

The `on_set_position_request_received` method will now be invoked every time a message is published to the subscribed topic `"seatadjuster/setPosition/response"`. The message data (string) is provided as parameter. In the example above the data is parsed from json (`data = json.loads(data_str)`).

In order to publish data to topics, the SDK provides the appropriate convenience method: `self.publish_mqtt_event()` which will be added to the `on_seat_position_changed` callback function from before.

```Python
    async def on_seat_position_changed(self, data: DataPointReply):
        response_topic = "seatadjuster/currentPosition"
        position = data.get(self.Vehicle.Cabin.Seat.Row1.Pos1.Position).value
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

and last but not least a `main()` method to run the app.

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

    with mock.patch.object(
        VehicleApp, "publish_mqtt_event", new_callable=mock.AsyncMock, return_value=-1
    ):
        response = await VehicleApp.publish_mqtt_event(
            str("sampleTopic"), get_sample_request_data()  # type: ignore
        )
        assert response == -1


def get_sample_request_data():
    return {"position": 330, "requestId": 123}
```

Looking at a test you notice the annotation `@pytest.mark.asyncio`. This is required if the test is defined as a coroutine. The next step is to create a mock from all the external dependencies. The method takes 4 arguments: first is the object to be mocked, second the method for which you want to modify the return value, third a callable and the last argument is the return value.
After creating the mock, you can test the method and check the response. Use asserts to make your test fail if the response does not match.

## See the results

Once the implementation is done, it is time to run and debug the app.

### Run your App

In order to run the app make sure the `devenv-runtimes` package is part of your [`.velocitas.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) (which should be the default) and the runtime is up and running. Read more about it in the [run runtime services](/docs/tutorials/vehicle_app_runtime/local_runtime) section.

Now chose one of the options to start the VehicleApp under development:

1. Press <kbd>F5</kbd>

or:

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `Local Runtime - Run VehicleApp`

### Debug your _Vehicle App_

In the [introduction about debugging](/docs/tutorials/quickstart/quickstart/#how-to-debug-your-_vehicle-app_), you saw how to start a debugging session. In this section, you will learn what is happening in the background.

The debug session launch settings are already prepared for the `VehicleApp` in `/.vscode/launch.json`.

```JSON
{
    "configurations": [
        {
            "type": "python",
            "justMyCode": false,
            "request": "launch",
            "name": "VehicleApp",
            "program": "${workspaceFolder}/app/src/main.py",
            "console": "integratedTerminal",
            "env": {
                "SDV_MIDDLEWARE_TYPE": "native",
                "SDV_VEHICLEDATABROKER_ADDRESS": "grpc://127.0.0.1:55555",
                "SDV_MQTT_ADDRESS": "mqtt://127.0.0.1:1883"
            }
        }
    ]
}
```

We specify which python-script to run using the `program` key.

You can adapt the configuration in `/.vscode/launch.json` and in `/.vscode/tasks.json` to your needs (e.g., change the ports, add new tasks) or even add a completely new configuration for another _Vehicle App_.

Once you are done, you have to switch to the debugging tab (sidebar on the left) and select your configuration using the dropdown on the top. You can now start the debug session by clicking the play button or <kbd>F5</kbd>. Debugging is now as simple as in every other IDE, just place your breakpoints and follow the flow of your _Vehicle App_.

## Next steps

- Concept: [SDK Overview](/docs/concepts/development_model/vehicle_app_sdk)
- Tutorial: [Deploy runtime services in Kanto](/docs/tutorials/vehicle_app_runtime/kanto_runtime)
- Tutorial: [Start runtime services locally](/docs/tutorials/vehicle_app_runtime/local_runtime)
- Tutorial: [Creating a Python Vehicle Model](/docs/tutorials/vehicle_model_creation)
- Tutorial: [Develop and run integration tests for a _Vehicle App_](/docs/tutorials/vehicle_app_development/integration_tests)
- Concept: [Deployment Model](/docs/concepts/deployment_model/)
