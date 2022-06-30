---
title: "Python Vehicle App SDK Overview"
date: 2022-05-09T13:43:25+05:30
aliases:
  - /python-sdk/python_vehicle_app_sdk_overview.md
resources:
- src: "**pyhon_sdk_overview*.png"
---

## Introduction

The Python Vehicle App SDK consists of the following building blocks:

- **[Vehicle Model Ontology](#vehicle-model-ontology)**: The SDK provides a set of model base classes for the creation of vehicle models.

- **[Middleware integration](#middleware-integration)**: Vehicle Models can contain gRPC stubs to communicate with Vehicle Services. gRPC communication is integrated with the [Dapr](https://dapr.io) middleware for service discovery and [OpenTelemetry](https://opentelemetry.io) tracing.

- **[Fluent query & rule construction](#Fluent-query--rule-construction)**: Based on a concrete Vehicle Model, the SDK is able to generate queries and rules against the Vehicle Data Broker to access the real values of the data points that are defined in the vehicle model.

- **[Publish & subscribe messaging](#publish--subscribe-messaging)**: The SDK supports publishing messages to a MQTT broker and subscribing to topics of a MQTT broker.

- **[Vehicle App abstraction](#Vehicle-App-abstraction)**: Last but not least the SDK provides a Vehicle App base class, which every Vehicle App derives from.

An overview of the Vehicle App SDK for Python and its dependencies is depicted in the following diagram:

{{< imgproc pyhon_sdk_overview Resize "800x" >}}
  Overview of Python SDK architecture
{{< /imgproc >}}

## Vehicle Model Ontology

The Vehicle Model is a tree-based model where every branch in the tree, including the root, is derived from the Model base class.

The Vehicle Model Ontology consists of the following classes:

### Model

A model contains services, data points and other models. It corresponds to branch entries in VSS or interfaces in DTDL or namespaces in VSC.

### ModelCollection

Specifications like VSS support a concept that is called [Instances](https://covesa.github.io/vehicle_signal_specification/rule_set/instances/). It makes it possible to describe repeating definitions. In DTDL, such kind of structures may be modeled with [Relationships](https://github.com/Azure/opendigitaltwins-dtdl/blob/master/DTDL/v2/dtdlv2.md#relationship). In the SDK, these structures are mapped with the `ModelCollection` class. A `ModelCollection` is a collection of models, which make it possible to reference an individual model either by a `NamedRange` (e.g., Row [1-3]), a `Dictionary` (e.g., "Left", "Right") or a combination of both.

### Service

Direct synchronous communication between Vehicle Apps and Vehicle Services is supposed to be facilitated over the [gRPC](https://grpc.io) protocol.

The SDK has its own `Service` base class, which provides a convenience API layer to access the exposed methods of exactly one gRPC endpoint of a Vehicle Service or another Vehicle App. Please see the [Middleware Integration](#middleware-integration) section for more details.

### DataPoint

`DataPoint` is the base class for all data points. It corresponds to sensors/actuators in VSS or telemetry / properties in DTDL.

Data Points are the signals that are typically emitted by Vehicle Services.

The representation of a data point is a path starting with the root model, e.g.:

- `Vehicle.Speed`
- `Vehicle.FuelLevel`
- `Vehicle.Cabin.Seat.Row1.Pos1.Position`

Data points are defined as attributes of the model classes. The attribute name is the name of the data point without its path.

### Typed DataPoint classes

Every primitive datatype has a corresponding typed data point class, which is derived from `DataPoint` (e.g., `DataPointInt32`, `DataPointFloat`, `DataPointBool`, `DataPointString`, etc.).

### Example

An example of a Vehicle Model created with the described ontology is shown below:

````python
```Python

# import ontology classes
from sdv import (
    DataPointDouble,
    Model,
    Service,
    DataPointInt32,
    DataPointBool,
    DataPointArray,
    DataPointString,
    ModelCollection,
    NamedRange
)

class Seat(Model):
    def __init__(self, parent):
        super().__init__(parent)
        self.Position = DataPointBool("Position", self)
        self.IsOccupied = DataPointBool("IsOccupied", self)
        self.IsBelted = DataPointBool("IsBelted", self)
        self.Height = DataPointInt32("Height", self)
        self.Recline = DataPointInt32("Recline", self)

class Cabin(Model):
    def __init__(self, parent: Model):
        super().__init__(parent)

        self.DriverPosition = DataPointInt32("DriverPosition", self)
        self.Seat = ModelCollection[Seat](
            [NamedRange("Row", 1, 2), NamedRange("Pos", 1, 3)], Seat(self)
        )

class VehicleIdentification(Model):
    def __init__(self, parent):
        super().__init__(parent)
        self.VIN = DataPointString("VIN", self)
        self.Model = DataPointString("Model", self)

class CurrentLocation(Model):
    def __init__(self, parent):
        super().__init__(parent)
        self.Latitude = DataPointDouble("Latitude", self)
        self.Longitude = DataPointDouble("Longitude", self)
        self.Timestamp = DataPointString("Timestamp", self)
        self.Altitude = DataPointDouble("Altitude", self)

class Vehicle(Model):
    def __init__(self):
        super().__init__()
        self.Speed = DataPointFloat("Speed", self)
        self.CurrentLocation = CurrentLocation(self)
        self.Cabin = Cabin(self)

vehicle = Vehicle()
````

## Middleware integration

### gRPC Services

Vehicle Services are expected to expose their public endpoints over the gRPC protocol. The related protobuf definitions are used to generate Python method stubs for the Vehicle Model to make it possible to call the methods of the Vehicle Services.

### Model integration

Based on the `.proto` files of the Vehicle Services, the protocol buffers compiler generates special Python descriptors for all rpcs, messages, fields etc.
The gRPC stubs are wrapped by a **convenience layer** class derived from `Service` that contains all the methods of the underlying protocol buffer specification.

```Python
class SeatService(Service):
    def __init__(self):
        super().__init__()
        self._stub = SeatsStub(self.channel)

    async def Move(self, seat: Seat):
        response = await self._stub.Move(
            MoveRequest(seat=seat), metadata=self.metadata
        )
        return response
```

### Service discovery

The underlying gRPC channel is provided and managed by the Service base class of the SDK. It is also responsible for routing the method invocation to the service through dapr middleware. As a result, a `dapr-app-id` has to be assigned to every `Service`, so that dapr can discover the corresponding vehicle services. This `dapr-app-id` has to be specified as an environment variable named `<service_name>_DAPR_APP_ID`.

## Fluent query & rule construction

A set of query methods like `get()`, `where()`, `join()` etc. are provided through the `Model` and `DataPoint` base classes. These functions make it possible to construct SQL-like queries and subscriptions in a fluent language, which are then transmitted through the gRPC interface to the Vehicle Data Broker.

### Query examples

The following examples show you how to query data points.

#### Get single datapoint

```Python
driver_pos: int = vehicle.Cabin.DriverPosition.get()

# Call to broker:
# GetDataPoint(rule="SELECT Vehicle.Cabin.DriverPosition")
```

#### Get datapoints from multiple branches

```Python
vehicle_data = vehicle.CurrentLocation.Latitude.join(
    vehicle.CurrentLocation.Longitude).get()

print(f'
    Latitude: {vehicle_data.CurrentLocation.Latitude}
    Longitude: {vehicle_data.CurrentLocation.Longitude}

# Call to broker:
# GetDataPoint(rule="SELECT Vehicle.CurrentLocation.Latitude, CurrentLocation.Longitude")
```

### Subscription examples

#### Subscribe and Unsubscribe to a single datapoint

```Python

self.rule = (
    await self.vehicle.Cabin.Seat.element_at(2,1).Position
    .subscribe(self.on_seat_position_change)
)

def on_seat_position_change(int position):
    print(f'Seat position changed to {position}')

# Call to broker:
# Subscribe(rule="SELECT Vehicle.Cabin.Seat.Row2.Pos1.Position")

# If needed, the subscription can be stopped like this:
await self.rule.subscription.unsubscribe()
```

#### Subscribe to a single datapoint with a filter

```Python
vehicle.Cabin.Seat.element_at(2,1).Position.where(
    "Cabin.Seat.Row2.Pos1.Position > 50")
    .subscribe(on_seat_position_change)

def on_seat_position_change(int position):
    print(f'Seat position changed to {position}')

# Call to broker:
# Subscribe(rule="SELECT Vehicle.Cabin.Seat.Row2.Pos1.Position WHERE Vehicle.Cabin.Seat.Row2.Pos1.Position > 50")
```

## Publish & subscribe messaging

The SDK supports publishing messages to a MQTT broker and subscribing to topics of a MQTT broker. By leveraging the dapr pub/sub building block for this purpose, the low-level MQTT communication is abstracted away from the `Vehicle App` developer. Especially the physical address and port of the MQTT broker is no longer configured in the `Vehicle App` itself, but rather is part of the dapr configuration, which is outside of the `Vehicle App`.

### Publish MQTT Messages

MQTT messages can be published easily with the `publish_mqtt_event()` method, inherited from `VehicleApp` base class:

```python
await self.publish_mqtt_event(
    "seatadjuster/currentPosition", json.dumps(req_data))
```

### Subscribe to MQTT Topics

Subscriptions to MQTT topics can be easily established with the `subscribe_topic()` annotation. The annotation needs to be applied to a method of the `Vehicle App` class.

```python
@subscribe_topic("seatadjuster/setPosition/request")
async def on_set_position_request_received(self, data: str) -> None:
    data = json.loads(data)
    logger.info("Set Position Request received: data=%s", data)
```

Under the hood, the vehicle app creates a grpc endpoint on port `50008`, which is exposed to the dapr middleware. The dapr middleware will then subscribe to the MQTT broker and forward the messages to the vehicle app.

To change the app port, set it in the `main()` method of the app:

```python
from sdv import conf

async def main():
    conf.DAPR_APP_PORT = <your port>
```

## Vehicle App abstraction

`Vehicle Apps` are inherited from the `VehicleApp` base class. This enables the `Vehicle App` to use the Publish & subscribe messaging and the Vehicle Data Broker.

The `Vehicle Model` instance is passed to the `__init__` method of the `VehicleApp` class and should be stored in a `self.vehicle` attribute, to be used in event handler functions.

Finally, the `run()` method of the `VehicleApp` class is called to start the `Vehicle App` and register all MQTT topic and Vehicle Data Broker subscriptions. The subscriptions are based on `asyncio`, which makes it necessary to call the `run()` method with an active `asyncio event_loop`.

A typical skeleton of a `Vehicle App` looks like this:

````Python

```Python
class SeatAdjusterApp(VehicleApp):
    def __init__(self, vehicle: Vehicle):
        super().__init__()
        self.vehicle = vehicle

async def main():
    seat_adjuster_talent = SeatAdjusterApp(vehicle)
    await seat_adjuster_talent.run()


LOOP = asyncio.get_event_loop()
LOOP.add_signal_handler(signal.SIGTERM, LOOP.stop)
LOOP.run_until_complete(main())
LOOP.close()
````
