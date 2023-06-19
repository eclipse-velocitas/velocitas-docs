---
title: "C++ Vehicle App Development"
date: 2022-05-09T13:43:25+05:30
weight: 2
description: >
  Learn how to develop and test a _Vehicle App_ using C++.
aliases:
  - /docs/tutorials/cpp/tutorial_how_to_create_a_vehicle_app_cpp.md
---

> We recommend that you make yourself familiar with the [Vehicle App SDK](/docs/concepts/development_model/vehicle_app_sdk) first, before going through this tutorial.

The following information describes how to develop and test the sample _Vehicle App_ that is included in the [template repository](https://github.com/eclipse-velocitas/vehicle-app-cpp-template). You will learn how to use the Vehicle App SDK and how to interact with the Vehicle Model.

Once you have completed all steps, you will have a solid understanding of the development workflow and you will be able to reuse the template repository for your own _Vehicle App_ development project.

## Develop your first Vehicle App

This section describes how to develop your first _Vehicle App_. Before you start building a new _Vehicle App_, make sure you have already read this manual:

- [Setup and Explore Development Environment](/docs/tutorials/quickstart.md)

Once you have established your development environment, you will be able to start developing your first _Vehicle App_.

For this tutorial, you will recreate the vehicle app that is included with the [template repository](https://github.com/eclipse-velocitas/vehicle-app-cpp-template):
The _Vehicle App_ allows to change the positions of the seats in the car and also provide their current positions to other applications.

A detailed explanation of the use case and the example is available [here](/docs/velocitas/docs/seat_adjuster_use_case.md).

At first, you have to create the main c++ file which we will call `App.cpp` in `/app/src`. All the relevant code for new _Vehicle App_ goes there. Afterwards, there are several steps you need to consider when developing the app:

1. [Manage your includes](#manage-your-imports)
2. [Initialize your class](#initialize-your-class)
3. [Start the app](#start-the-app)

### Manage your imports

Before you start development in the `App.cpp` you just created, it will be necessary to include all required files, which you will understand better later through the development:

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

The main class of your new _Vehicle App_ needs to inherit the `VehicleApp` provided by the [SDK](https://github.com/eclipse-velocitas/vehicle-app-cpp-sdk).

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
                 IPubSubClient::createInstance("localhost:1883", "MyVehicleApp")) // the URI to the MQTT broker and the client ID of the MQTT client.
    {}
{}
```

Now, you have initialized the app and can continue developing relevant methods.

### Start the app

Here's an example of how to start the `MyVehicleApp` app that we just developed:

```Cpp
int main(int argc, char** argv) {
    MyVehicleApp app;
    app.run();
    return 0;
}
```

The app is now running. In order to use it properly, we will enhance the app with more features in the next sections.

## Vehicle Model Access

In order to facilitate the implementation, the whole vehicle is abstracted into model classes. Please check [tutorial about creating models](/docs/tutorials/vehicle_model_creation) for more details about this topic. In this section, the focus is on using the models.

The first thing you need to do is to get access to the Vehicle Model. If you derived your project repository from our template, we already provide a generated model in the folder `app/vehicle_model/include/`. This folder is already configured as "include folder" of the CMake tooling. Hence, in most cases no additional setup is necessary. How to tailor the model to your needs or how you could get access to vehicle services is described in the tutorial linked above.

If you want to access a single [DataPoint](/docs/concepts/development_model/vehicle_app_sdk/#datapoint) for the vehicle speed, this can be done via

```Cpp
auto vehicleSpeedBlocking = getDataPoint(Vehicle.Speed)->await();
getDataPoint(Vehicle.Speed)->onResult([](auto vehicleSpeed){
    logger().info("Got speed!");
})
```

`getDataPoint()` returns a `shared_ptr` to an `AsyncResult` which, as the name implies, is the result of an asynchronous operation. We have two options to access the value of the asynchronous result. First we can use `await()` and block the calling thread until a result is available or use `onResult(...)` which allows us to inject a function pointer or a lambda which is called once the result becomes available.

If you want to get deeper inside the vehicle, to access a single seat for example, you just have to go the model-chain down:

```Cpp
auto driverSeatPosition = getDataPoint(Vehicle.Cabin.Seat.Row(1).Pos(1).Position)->await();
```

## Subscription to DataPoints

If you want to get notified about changes of a specific `DataPoint`, you can subscribe to this event, e.g. as part of the `onStart()` method in your app.

```Cpp
void onStart() override {
    subscribeDataPoints(QueryBuilder::select(Vehicle.Cabin.Seat.Row(1).Pos(1).Position).build())
        ->onItem([this](auto&& item) { onSeatPositionChanged(std::forward<decltype(item)>(item)); })
        ->onError([this](auto&& status) { onError(std::forward<decltype(status)>(status)); });
}

void onSeatPositionChanged(const DataPointsResult& result) {
    const auto dataPoint = result.get(Vehicle.Cabin.Seat.Row(1).Pos(1).Position);
    logger().info(dataPoint->value());
    // do something with the data point value
}

```

The `VehicleApp` class provides the `subscribeDataPoints()` method which allows to listen for changes on one or many data points. Once a change in any of the data points is registered, the callback registered via `AsyncSubscription::onItem()` is called. Conversely, the callback registered via `AsyncSubscription::onError()` is called once there is any error during communication with the KUKSA data broker.

The result passed to the callback registered via `onItem()` is an object of type `DataPointsResult` which holds all data points that have changed. Individual data points can be accessed directly by their reference: `result.get(Vehicle.Cabin.Seat.Row(1).Pos(1).Position)`)

## Services

{{% alert title="Note" %}}Services are not supported by our [automated vehicle model lifecycle](/docs/tutorials/vehicle_model_creation/automated_model_lifecycle) for the time being. If you need access to services please read [here](/docs/tutorials/vehicle_model_creation/manual_model_creation) how you can create a model and add services to it manually.{{% /alert %}}

Services are used to communicate with other parts of the vehicle via remote function calls (RPC). Please read the basics about them [here](/docs/tutorials/vehicle_model_creation/manual_model_creation/manual_creation_python/#add-a-vehicle-service).

The following few lines show you how to use the `moveComponent()` method of the `SeatService` you have created:

```Cpp
vehicle::cabin::SeatService::SeatLocation location{1, 1};
Vehicle.Cabin.SeatService.moveComponent(
    location, vehicle::cabin::SeatService::Component::Base, 300
    )->await();
```

In order to know which seat to move, you have to pass a `SeatLocation` object as the first parameter. The second argument specifies the component to be moved. The possible components are defined in the proto-files. The last parameter to be passed into the method is the final position of the component.

> Make sure to call the `await()` method when calling service methods or register a callback via `onResult()` otherwise you don't know when your asynchronous call will finish.

### MQTT

Interaction with other Vehicle Apps or the cloud is enabled by using Mosquitto MQTT Broker. The MQTT broker runs inside a docker image, which is started automatically after starting the DevContainer.

In the [quickstart section](/docs/tutorials/quickstart") about the Vehicle App, you already tested sending MQTT messages to the app.
In the previous sections, you generally saw how to use `Vehicle Models`, `DataPoints` and `GRPC Services`. In this section, you will learn how to combine them with MQTT.

In order to receive and process MQTT messages inside your app, simply use the `VehicleApp::subscribeTopic` method provided by the SDK:

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

The `onSetPositionRequestReceived` method will now be invoked every time a message is created on the subscribed topic `"seatadjuster/setPosition/response"`. The message data (string) is provided as parameter. In the example above the data is parsed to json (`data = json.loads(data_str)`).

In order to publish data to other subscribers, the SDK provides the appropriate convenience method: `VehicleApp::publishToTopic(...)`

```Cpp
void MyVehicleApp::onSeatPositionChanged(const DataPointsResult& result):
    const auto responseTopic = "seatadjuster/currentPosition";
    nlohmann::json respData({"position": result.get(Vehicle.Cabin.Seat.Row(1).Pos(1).Position)->value()});

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

If you want to run the app together with a Dapr sidecar and use the Dapr middleware, you have to use the "dapr run ..." command to start your app:

```bash
dapr run --app-id myvehicleapp --app-port 50008 --config ./.dapr/config.yaml --components-path ./.dapr/components build/bin/App
```

You already have seen this command and how to check if it is working in the [general setup]({{< ref "/docs/tutorials/quickstart" >}}).

2 parameters may be unclear in this command:

- the config file `config.yaml`
- the components-path

For now, you just need to know that these parameters are needed to make everything work together.

The config.yaml has to be placed in the folder called `.dapr` and has the following content:

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

If you want to know more about dapr and the configuration, please visit the [dapr documentation](https://dapr.io).

### Debug your Vehicle App

In the [introduction about debugging]("/docs/tutorials/quickstart#how-to-debug-_Vehicle-App_"), you saw how to start a debugging session. In this section, you will learn what is happening in the background.

The debug session launch settings are already prepared for the `VehicleApp`.

```JSON
"configurations": [
    {
        "name": "VehicleApp - Debug (dapr)",
        "type": "cppdbg",
        "request": "launch",
        "program": "${workspaceFolder}/build/bin/App",
        "args": [],
        "stopAtEntry": false,
        "cwd": "${workspaceFolder}",
        "environment": [
            {
                "name": "DAPR_GRPC_PORT",
                "value": "50001"
            },
            {
                "name": "DAPR_HTTP_PORT",
                "value": "3500"
            }
        ],
        "externalConsole": false,
        "MIMode": "gdb",
        "setupCommands": [
            {
                "description": "Enable pretty-printing for gdb",
                "text": "-enable-pretty-printing",
                "ignoreFailures": true
            },
            {
                "description": "Set Disassembly Flavor to Intel",
                "text": "-gdb-set disassembly-flavor intel",
                "ignoreFailures": true
            }
        ],
        "preLaunchTask": "dapr-VehicleApp-run",
        "postDebugTask": "dapr-VehicleApp-stop"
    }
]
```

We specify which binary to run using the `program` key. With the `preLaunchTask` and `postDebugTask` keys, you can also specify tasks to run before or after debugging. In this example, DAPR is set up to start the app before and stop it again after debugging. Below you can see the 2 tasks.

```JSON
{
    "label": "dapr-VehicleApp-run",
    "appId": "myvehicleapp",
    "componentsPath": "./.dapr/components",
    "config": "./.dapr/config.yaml",
    "grpcPort": 50001,
    "httpPort": 3500,
    "type": "dapr",
    "presentation": {
        "close": true,
        "reveal": "never"
    },
}
```

```JSON
{
    "label": "dapr-VehicleApp-stop",
    "type": "shell",
    "command": [
        "dapr stop --app-id myvehicleapp"
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

- Concept: [SDK Overview](/docs/concepts/development_model/vehicle_app_sdk)
- Tutorial: [Deploy runtime services in Kubernetes](/docs/tutorials/run_runtime_services_kubernetes.md)
- Tutorial: [Start runtime services locally](/docs/tutorials/run_runtime_services_locally.md)
- Tutorial: [Creating a Vehicle Model](/docs/tutorials/vehicle_model_creation)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/integration_tests.md)
- Concept: [Deployment Model](/docs/concepts/deployment_model)
- Tutorial: [Deploy a _Vehicle App_ with Helm](/docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md)
