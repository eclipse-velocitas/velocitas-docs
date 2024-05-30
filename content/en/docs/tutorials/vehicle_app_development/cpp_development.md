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
    vehicle::Vehicle Vehicle; // this member exists to provide simple access to the vehicle model
}
```

In your constructor, you have to choose which implementations to use for the VehicleDataBrokerClient and the PubSubClient. By default we suggest you use the factory methods to generate the default implementations: `IVehicleDataBrokerClient::createInstance` and `IPubSubClient::createInstance`. These will create a VehicleDataBrokerClient which connects to the VAL via gRPC and an MQTT-based pub-sub client.

```Cpp
MyVehicleApp()
    : VehicleApp(IVehicleDataBrokerClient::createInstance("vehicledatabroker"), // this is the app-id of the KUKSA Databroker in the VAL.
                 IPubSubClient::createInstance("MyVehicleApp")) // the clientId identifies the client at the pub/sub broker
    {}
{}
```

{{% alert title="Note" %}}
The URI of the MQTT broker is by default `localhost:1883` and can be set to another address via the environment variable `SDV_MQTT_ADDRESS` (beginning with C++ SDK v0.3.3) or `MQTT_BROKER_URI` (SDKs before v0.3.3).
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

In order to facilitate the implementation, the whole set of vehicle signal is abstracted into model classes. Please check the [tutorial about creating models](/docs/tutorials/vehicle_model_creation) for more details. In this section, the focus is on using the model.

The first thing you need to do is to get access to the Vehicle Model. If you derived your project repository from our template, we already provide a generated model as a Conan source package. The library is already referenced as "include folder" in the CMake files. Hence, in most cases no additional setup is necessary. How to tailor the model to your needs or how you could get access to vehicle services is described in the tutorial linked above.  In your source code the model is included via `#include "vehicle/Vehicle.hpp"` (as shown above).

If you want to read a single [signal/data point](/docs/concepts/development_model/vehicle_app_sdk/#datapoint) e.g. for the vehicle speed, the simplest way is to do it via a blocking call and directly accessing the value of the speed:

```Cpp
auto vehicleSpeed = Vehicle.Speed.get()->await().value();
```

Lets have a look, what this line contains:
* The term `Vehicle.Speed` addresses the signal we like to query, i.e. the current speed of the vehicle.
* The term `.get()` tells that we want to get/read the current state of that signal from the Data Broker.
  Behind the scenes this triggers an request-response flow via IPC with the Data Broker.
* The term `->await()` blocks the execution until the response was received.
* Finally, the term `.value()` tries to access the returned speed value.

The `get()` returns a `shared_ptr` to an `AsyncResult` which, as the name implies, is the result of an asynchronous operation. We have two options to access the value of the asynchronous result. First we can use `await()` and block the calling thread until a result is available or use `onResult(...)` which allows us to inject a function pointer or a lambda which is called once the result is available:

```Cpp
Vehicle.Speed.get()
    ->onResult([](auto vehicleSpeed){
        logger().info("Got speed!");
    })
    ->onError(auto status){
        logger().info("Something went wrong communicating to the data broker!");
    });
```

If you want to get deeper inside to the vehicle, to access a single seat for example, you just have to go the model-chain down:

```Cpp
auto driverSeatPosition = Vehicle.Cabin.Seat.Row1.Pos1.Position.get()->await();
```

### Class TypedDataPointValue

If you have a detailed look at the `AsyncResult` class, you will observe that the object returned by the `await()` or passed to the `onResult` callback is not directly the current value of the signal, but instead an object of type `TypedDataPointValue`. This object does not only contains the current value of the signal but also some additional metadata accessible via these functions:
* `getPath()` provides the signal name, i.e. the complete path,
* `getType()` provides the data type of the signal,
* `getTimeStamp()` provides the timestamp when the current state was received by the data broker,
* `isValid()` returns `true` if the current state repesents a valid value of the signal or `false` otherwise,
* `getFailure()` returns the reason, why the current state does **not** represent a valid value (it returns `NONE` if the value is valid),
* `getValue()` returns the a valid current value. It will throw an `InvalidValueException` if the current value is invalid for whatever reason.

The latter three points lead us to

### Failure Handling

As indicated above, there might be reasons/situations why the get operation is not able to deliver a valid value for the requested signal. Those shall be handled properly by any application (that wants "to be more" than a prototype).

There are two ways to handle the failure situations:
* Either you can catch the exception thrown by the `.value()` function:
```Cpp
try {
    auto vehicleSpeed = Vehicle.Speed.get()->await().value();
    // use the speed value
} catch (AsyncException& e) {
    // thrown by the await(): Something went wrong on communication level with the data broker
} catch (InvalidValueException& e) {
    // thrown by .value(): The vehicle speed signal does not contain a valid value, currently
}
```
* Throwing the `InvalidValueException`can be avoided if you first check that `.isValid()` returns true before calling `.value()`: 
```Cpp
auto vehicleSpeed = Vehicle.Speed.get()->await();
if (vehicleSpeed.isValid())
    // Accessing .value() now wont throw an exception
    auto speed = vehicleSpeed.value()
    ...
} else {
    // Do your failure handling here
    switch (vehicleSpeed.getFailure()) {
    case Failure::INVALID_VALUE:
        ...
        break;
    case ...
    default:
         ...
    }
}
```
(`isValid()` is a convenience function for checking `.getFailure() == Failure::NONE`.)

{{% alert title="Note" %}
If you use the asynchroneous variant, the callback passed to `onError` is just called to report errors on communication level with the data broker. The validity of the returned signal's/data point's value needs to be checked separatly (e.g. via 'isValid()')!
{{% alert %}

## Failure Reasons

There are two levels where errors accessing signal/data points might occure.

### Communication with the Data Broker (IPC Level)

The data broker might be (temporarly) unavailable because
* it's not yet started up,
* temporary "stopped" due to a crash or a "live update",
* some temporary network issues (if running on a different hardware node),
* ...

Errors on the IPC level between the application and the data broker will be reported either via
* an `AsyncException` thrown by the `await()` function of the `AsyncResult` class or
* calling the function passed to the `onError` function of the `AsyncResult`/`AsyncSubscription` class.

### Signal / Data Point Level

The reasons why a valid value of signal/data point can be missing are explained here:
* The addressed signal/data point might be "unknown" on the system (`Failure::UNKNOWN_DATAPOINT`). This can be a hint for a misconfiguration of the overall system, because no provider is installed in that system which will provide this signal. It can be acceptable, if an application does just "optionally" require access to that signal and would work properly without it being present.
* The application might have not the necessary access rights to the addressed signal/data point (`Failure::ACCESS_DENIED`). This can be a hint for a misconfiguration of the overall system, but could be also a "normal" situation if the user of the vehicle blocks access to certain signals for that application.
* The addressed signal/data point might be temporary not available (`Failure::NOT_AVAILABLE`). This is a normal situation which will arise, while the provider of that signal is
  * not yet started up or not yet passed a value to the data broker,
  * temporary "stopped" due to a crash or a "live update",
  * some temporary network issues (if the provider is running on a different hardware node),
  * ...
* The addressed signal/data point might currently not represent a valid value (`Failure::INVALID_VALUE`). This situation means, that the signal is currently provided but just the value itself is not representable, e.g. because the hardware sensor delivers implausible values.
* The value of is missing because of some internal issue in the data broker (`Failure::INTERNAL_ERROR`). This typically points out some misbehaviour within the broker's implementation - call it "bug".

It is the application implementer's decision if it makes sense to distinguish between the different failure reasons or if some or all of them can be handled as "just one".

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

The `VehicleApp` class provides the `subscribeDataPoints()` method which allows to listen for changes on one or multiple data points. Once a change in any of the data points is registered, the callback registered via `AsyncSubscription::onItem()` is called. Conversely, the callback registered via `AsyncSubscription::onError()` is called once there is an error during communication with the KUKSA Databroker.

The result passed to the callback registered via `onItem()` is an object of type `DataPointsResult` which holds the current state of all data points that were part if the respective subscription. The state of individual data points can be accessed by their reference: `result.get(Vehicle.Cabin.Seat.Row1.Pos1.Position)`)

{{% alert title="Note" %}
If you select multiple signals/data pints in a single subscription be aware that:
1. The update notification will not only contain those data points whose states were updated, but the state of all data points selected in the belonging subscription. If you don't want this behaviour, you must subscribe to change notifications for each signal/data points separately.
2. A possible failure state will be reported individually per signal/data point. The reason is, that each signal/data point might come from a different provider, has individual access rights, and individual reasons to become invalid. This is also true, if requesting multiple signal/data point states via a single get call.
{{% /alert %}}

## Services

Services are used to communicate with other parts of the vehicle via remote procedure calls (RPC). Please read the basics about them [here](/docs/tutorials/vehicle_model_creation/manual_model_creation/manual_creation_python/#add-a-vehicle-service).

{{% alert title="Note" %}}
This description is outdated!

Services were not supported by our [automated vehicle model lifecycle](/docs/tutorials/vehicle_model_creation/automated_model_lifecycle) for some time and could be made available via the [description](/docs/tutorials/vehicle_model_creation/manual_model_creation) how you can create a model and add services to it manually.

In-between we provide a way to refer gRPC based services by referencing the required proto files from the AppManifest and auto-generated the language-specific stubs. The necessary steps need being described here.
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

Now chose one of the options to start the VehicleApp under development:

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
            "name": "VehicleApp - Debug (Native)",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/build/bin/app",
            "args": [ ],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [
                {
                    "name": "SDV_MIDDLEWARE_TYPE",
                    "value": "native"
                },
                {
                    "name": "SDV_VEHICLEDATABROKER_ADDRESS",
                    "value": "127.0.0.1:55555"
                },
                {
                    "name": "SDV_MQTT_ADDRESS",
                    "value": "127.0.0.1:1883"
                }
            ],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [ ],
        }
    ]
}
```

We specify which binary to run using the `program` key. In the `environment` you can specify all needed environment variables.
You can adapt the JSON to your needs (e.g., change the ports, add new tasks) or even add a completely new configuration for another _Vehicle App_.

Once you are done, you have to switch to the debugging tab (sidebar on the left) and select your configuration using the dropdown on the top. You can now start the debug session by clicking the play button or <kbd>F5</kbd>. Debugging is now as simple as in every other IDE, just place your breakpoints and follow the flow of your _Vehicle App_.

## Next steps

- Concept: [SDK Overview](/docs/concepts/development_model/vehicle_app_sdk)
- Concept: [Deployment Model](/docs/concepts/deployment_model)
- Tutorial: [Deploy runtime services in Kanto](/docs/tutorials/vehicle_app_runtime/kanto_runtime)
- Tutorial: [Start runtime services locally](/docs/tutorials/vehicle_app_runtime/local_runtime)
- Tutorial: [Creating a Vehicle Model](/docs/tutorials/vehicle_model_creation)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/vehicle_app_development/integration_tests)
