---
title: "C++ Vehicle App Development"
date: 2022-05-09T13:43:25+05:30
weight: 2
description: >
  Learn how to develop and test a _Vehicle App_ using C++.
aliases:
  - /docs/tutorials/vehicle_app_development/cpp_development.md
---

> We recommend that you make yourself familiar with the [_Vehicle App_ SDK](/docs/concepts/development_model/vehicle_app_sdk) first, before going through this tutorial.

The following information describes how to develop and test the sample _Vehicle App_ that is included in the [C++ template repository](https://github.com/eclipse-velocitas/vehicle-app-cpp-template). You will learn how to use the _Vehicle App_ C++ SDK and how to interact with the Vehicle Model.

Once you have completed all steps, you will have a solid understanding of the development workflow and you will be able to reuse the template repository for your own _Vehicle App_ development project.

## Develop your first _Vehicle App_

This section describes how to develop your first _Vehicle App_. Before you start building a new _Vehicle App_, make sure you have already read this manual:

- [Quickstart](/docs/tutorials/quickstart.md)

For this tutorial, you will recreate the _Vehicle App_ that is included in the [template repository](https://github.com/eclipse-velocitas/vehicle-app-cpp-template):
The _Vehicle App_ allows you to change the position of the driver's seat in the car and also provides its current positions to other applications.
A detailed explanation of the use case and the example is available [here](/docs/about/use_cases/seat_adjuster.md).

## Setting up the basic skeleton of your app

At first, you have to create the main C++ file which we will call `App.cpp` in `/app/src`. All the relevant code for your new _Vehicle App_ goes there. Afterwards, there are several steps you need to consider when developing the app:

1. [Manage your includes](#manage-your-includes)
2. [Initialize your class](#initialize-your-class)
3. [Define the entry point of your app](#entry-point-of-your-app)

### Manage your includes

Before you start development in the `App.cpp` you just created, it will be necessary to include all required header files, which you will understand better later through the development:

```Cpp
#include "sdk/VehicleApp.h"
#include "sdk/IPubSubClient.h"
#include "sdk/IVehicleDataBrokerClient.h"
#include "sdk/Logger.h"

#include "vehicle/Vehicle.hpp"

#include <memory>

using namespace velocitas;
```

### Initialize your class

The main class of your new _Vehicle App_ needs to inherit the `VehicleApp` provided by the [C++ SDK](https://github.com/eclipse-velocitas/vehicle-app-cpp-sdk).

```Cpp
class MyVehicleApp : public VehicleApp {
public:
    // <remaining code in this tutorial goes here>
private:
    ::Vehicle Vehicle; // this member exists to provide simple access to the vehicle model
}
```

In your constructor, you have to choose which implementations to use for the VehicleDataBrokerClient and the PubSubClient. By default we suggest you use the factory methods to generate the default implementations: `IVehicleDataBrokerClient::createInstance` and `IPubSubClient::createInstance`. These will create a VehicleDataBrokerClient which connects to the VAL via gRPC and an MQTT-based pub-sub client.

```Cpp
MyVehicleApp()
    : VehicleApp(IVehicleDataBrokerClient::createInstance("vehicledatabroker"), // this is the dapr-app-id of the KUKSA Databroker in the VAL.
                 IPubSubClient::createInstance("MyVehicleApp")) // the client ID of the MQTT client.
    {}
{}
```

{{% alert title="Note" %}}
The URI of the MQTT broker is by default `localhost:1883` and can be set to something else via the environment variable `SDV_MQTT_ADDRESS` (beginning with C++ SDK v0.3.3) or `MQTT_BROKER_URI` (SDKs before v0.3.3).
{{% /alert %}}

Now, you have initialized the app and can continue developing relevant methods.

### Entry point of your app

Here's an example of an entry point to the `MyVehicleApp` that we just developed:

```Cpp
int main(int argc, char** argv) {
    MyVehicleApp app;
    app.run();
    return 0;
}
```

With this your app can now be started. In order to provide some meaningful behaviour of the app, we will enhance it with more features in the next sections.

## Vehicle Model Access

In order to facilitate the implementation, the whole vehicle is abstracted into model classes. Please check the [tutorial about creating models](/docs/tutorials/vehicle_model_creation) for more details. In this section, the focus is on using the model.

The first thing you need to do is to get access to the Vehicle Model. If you derived your project repository from our template, we already provide a generated model in the folder `app/vehicle_model/include/`. This folder is already configured as "include folder" of the CMake tooling. Hence, in most cases no additional setup is necessary. How to tailor the model to your needs or how you could get access to vehicle services is described in the tutorial linked above.

If you want to access a single [DataPoint](/docs/concepts/development_model/vehicle_app_sdk/#datapoint) e.g. for the vehicle speed, this can be done via

```Cpp
auto vehicleSpeedBlocking = getDataPoint(Vehicle.Speed)->await();
```

or

```Cpp
getDataPoint(Vehicle.Speed)->onResult([](auto vehicleSpeed){
    logger().info("Got speed!");
})
```

`getDataPoint()` returns a `shared_ptr` to an `AsyncResult` which, as the name implies, is the result of an asynchronous operation. We have two options to access the value of the asynchronous result. First we can use `await()` and block the calling thread until a result is available or use `onResult(...)` which allows us to inject a function pointer or a lambda which is called once the result is available.

If you want to get deeper inside to the vehicle, to access a single seat for example, you just have to go the model-chain down:

```Cpp
auto driverSeatPosition = getDataPoint(Vehicle.Cabin.Seat.Row1.Pos1.Position)->await();
```

## Subscription to DataPoints

If you want to get notified about changes of a specific `DataPoint`, you can subscribe to this event, e.g. as part of the `onStart()` method in your app:

```Cpp
void onStart() override {
    subscribeDataPoints(QueryBuilder::select(Vehicle.Cabin.Seat.Row1.Pos1.Position).build())
        ->onItem([this](auto&& item) { onSeatPositionChanged(std::forward<decltype(item)>(item)); })
        ->onError([this](auto&& status) { onError(std::forward<decltype(status)>(status)); });
}

void onSeatPositionChanged(const DataPointsResult& result) {
    const auto dataPoint = result.get(Vehicle.Cabin.Seat.Row1.Pos1.Position);
    logger().info(dataPoint->value());
    // do something with the data point value
}

```

The `VehicleApp` class provides the `subscribeDataPoints()` method which allows to listen for changes on one or many data points. Once a change in any of the data points is registered, the callback registered via `AsyncSubscription::onItem()` is called. Conversely, the callback registered via `AsyncSubscription::onError()` is called once there is any error during communication with the KUKSA data broker.

The result passed to the callback registered via `onItem()` is an object of type `DataPointsResult` which holds all data points that have changed. Individual data points can be accessed directly by their reference: `result.get(Vehicle.Cabin.Seat.Row1.Pos1.Position)`)

## Services

Services are used to communicate with other parts of the vehicle via remote procedure calls (RPC). Please read the basics about them [here](/docs/tutorials/vehicle_model_creation/manual_model_creation/manual_creation_python/#add-a-vehicle-service).

{{% alert title="Note" %}}
Services are not supported by our [automated vehicle model lifecycle](/docs/tutorials/vehicle_model_creation/automated_model_lifecycle) for the time being. If you need access to services please read [here](/docs/tutorials/vehicle_model_creation/manual_model_creation) how you can create a model and add services to it manually.
{{% /alert %}}

The following code snippet shows how to use the `moveComponent()` method of the `SeatService` from the vehicle model:

```Cpp
vehicle::cabin::SeatService::SeatLocation location{1, 1};
Vehicle.Cabin.SeatService.moveComponent(
    location, vehicle::cabin::SeatService::Component::Base, 300
    )->await();
```

In order to define which seat you like to move, you have to pass a `SeatLocation` object as the first parameter. The second argument specifies the component of the seat to be moved. The possible components are defined in the proto-files. The last parameter to be passed into the method is the final position of the component.

> Make sure to call the `await()` method when calling service methods or register a callback via `onResult()` otherwise you don't know when your asynchronous call will finish.

### MQTT

Interaction with other _Vehicle Apps_ or with the cloud is enabled by using the Mosquitto MQTT Broker. When using the provided template repository you can start a MQTT Broker as part the local runtime. More information can be found [here](/docs/tutorials/vehicle_app_runtime/local_runtime).

In the [quickstart section](/docs/tutorials/quickstart.md) about the _Vehicle App_, you already tested sending MQTT messages to the app.
In the previous sections, you generally saw how to use `Vehicle Models`, `DataPoints` and `GRPC Services`. In this section, you will learn how to combine them with MQTT.

In order to receive and process MQTT messages inside your app, simply use the `VehicleApp::subscribeTopic(<topic>)` method provided by the SDK:

```Cpp
void onStart() override {
    subscribeTopic("seatadjuster/setPosition/request")
        ->onItem([this](auto&& item){ onSetPositionRequestReceived(std::forward<decltype(item)>(item);)});
}

void onSetPositionRequestReceived(const std::string& data) {
    const auto jsonData = nlohmann::json::parse(data);
    const auto responseTopic = "seatadjuster/setPosition/response";
    nlohmann::json respData({{"requestId", jsonData["requestId"]}, {"result", {}}});
}
```

The `onSetPositionRequestReceived` method will now be invoked every time a message is created on the subscribed topic `seatadjuster/setPosition/response`. The message data is provided as a string parameter. In the example above the data is parsed to json (`data = json.loads(data_str)`).

In order to publish data to other subscribers, the SDK provides the appropriate convenience method: `VehicleApp::publishToTopic(...)`

```Cpp
void MyVehicleApp::onSeatPositionChanged(const DataPointsResult& result):
    const auto responseTopic = "seatadjuster/currentPosition";
    nlohmann::json respData({"position": result.get(Vehicle.Cabin.Seat.Row1.Pos1.Position)->value()});

    publishToTopic(
        responseTopic,
        respData.dump(),
    );
```

The above example illustrates how one can easily publish messages. In this case, every time the seat position changes, the new position is published to `seatadjuster/currentPosition`

## See the results

Once the implementation is done, it is time to run and debug the app.

### Build your App

Before you can run the _Vehicle App_ you need to build it first. To do so, simply run the provided `build.sh` script found in the root of the SDK. It does accept some arguments, but that is out of scope for this tutorial.

{{% alert title="Warning" color="warning" %}}
If this is your first time building, you might have to run `install_dependencies.sh` first.
{{% /alert %}}

### Run your App

In order to run the app make sure the `devenv-runtimes` package is part of your [`.velocitas.json`](https://github.com/eclipse-velocitas/vehicle-app-cpp-template/blob/main/.velocitas.json) (which should be the default) and the runtime is up and running. Read more about it in the [run runtime services](/docs/tutorials/vehicle_app_runtime/local_runtime) section.

Now chose one of the options to start the VehicleApp under development (including Dapr sidecar):

1. Press <kbd>F5</kbd>

or:

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `Local Runtime - Run VehicleApp`

### Debug your _Vehicle App_

In the [introduction about debugging](/docs/tutorials/quickstart/quickstart/#how-to-debug-your-_vehicle-app_), you saw how to start a debugging session. In this section, you will learn what is happening in the background.

The debug session launch settings are already prepared for the `VehicleApp`.

```JSON
{
    "configurations": [
        {
            "name": "VehicleApp - Debug (dapr run)",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/build/bin/app",
            "args": [ ],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [
                {
                    "name": "DAPR_HTTP_PORT",
                    "value": "3500"
                },
                {
                    "name": "DAPR_GRPC_PORT",
                    "value": "50001"
                },
                {
                    "name": "VEHICLEDATABROKER_DAPR_APP_ID",
                    "value": "vehicledatabroker"
                }
            ],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [ ],
            "preLaunchTask": "dapr-sidecar-start",
            "postDebugTask": "dapr-sidecar-stop",
        }
    ]
}
```

We specify which binary to run using the `program` key. In the `environment` you can specify all needed environment variables. With the `preLaunchTask` and `postDebugTask` keys, you can also specify tasks to run before or after debugging. In this example, DAPR is set up to start the app before and stop it again after debugging. Below you can see the 2 tasks.

```JSON
{
    "label": "dapr-sidecar-start",
    "detail": "Start Dapr sidecar (with dapr run) to be present for debugging the VehicleApp (used by launch config).",
    "type": "shell",
    "command": "velocitas exec runtime-local run-dapr-sidecar vehicleapp --dapr-grpc-port 50001 --dapr-http-port 3500",
    "group": "none",
    "isBackground": true,
    "presentation": {
        "close": true,
        "reveal": "never"
    }
}
```

```JSON
{
    "label": "dapr-sidecar-stop",
    "detail": "Stop Dapr sidecar after finish debugging the VehicleApp (used by launch config).",
    "type": "shell",
    "command": [
        "dapr stop --app-id vehicleapp"
    ],
    "presentation": {
        "close": true,
        "reveal": "never"
    }
}
```

You can adapt the JSON to your needs (e.g., change the ports, add new tasks) or even add a completely new configuration for another _Vehicle App_.

Once you are done, you have to switch to the debugging tab (sidebar on the left) and select your configuration using the dropdown on the top. You can now start the debug session by clicking the play button or <kbd>F5</kbd>. Debugging is now as simple as in every other IDE, just place your breakpoints and follow the flow of your _Vehicle App_.

## Next steps

- Concept: [SDK Overview](/docs/concepts/development_model/vehicle_app_sdk)
- Concept: [Deployment Model](/docs/concepts/deployment_model)
- Tutorial: [Deploy runtime services in Kubernetes](/docs/tutorials/vehicle_app_runtime/kubernetes_runtime)
- Tutorial: [Start runtime services locally](/docs/tutorials/vehicle_app_runtime/local_runtime)
- Tutorial: [Creating a Vehicle Model](/docs/tutorials/vehicle_model_creation)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/vehicle_app_development/integration_tests)
- Tutorial: [Deploy a _Vehicle App_ with Helm](/docs/tutorials/vehicle_app_deployment/helm_deployment.md)
