---
title: "Vehicle App Manifest"
date: 2023-05-31T13:33:25+05:30
weight: 30
aliases:
  - /docs/concepts/vehicle_app_manifest.md
description: >
  Learn more about the Vehicle App Manifest.

---

## Introduction

The _AppManifest_ defines the name and the requirements of a _Vehicle App_. The requirements are specified on interface level. The manifest defines the required service interfaces (e.g. gRPC functions) and the used vehicle model and accessed data points, but it does not define certain providers of those interfaces.
This concept provides flexibility by separating the requirements of a _Vehicle App_ from the definition of a concrete _Runtime_ and _Middleware_ configuration.

The AppManifest is the only source of truth in our _Vehicle App_ templates for:

- Local development environments and configs
- deployment specs generation
- Velocitas CI/CD workflow
- OCI Image creation

## Purpose

- The AppManifest contains necessary information about the runtime requirements (VehicleModel, interfaces) of the app
- The AppManifest contains all required (or optional) data points that are used in the _Vehicle App_ with the necessary access rights (read, write)
- The AppManifest is service provider/implementation agnostic, while the service configurations are part of a corresponding [Velocitas Lifecycle Management](/docs/concepts/lifecycle_management) runtime package

## Structure

```json
// AppManifest.json
{
   "name":"SampleApp",
   "vehicleModel":{
      "src":"https://github.com/COVESA/vehicle_signal_specification/releases/download/v3.0/vss_rel_3.0.json",
      "datapoints":[
         {
            "path":"Vehicle.Speed",
            "required":"true",
            "access":"read"
         }
      ]
   },
   "runtime":[
      "grpc://sdv.databroker.v1.Broker/GetDatapoints",
      "grpc://sdv.databroker.v1.Broker/Subscribe",
      "grpc://sdv.databroker.v1.Broker/SetDatapoints",
      "mqtt"
   ]
}
```

## Vehicle Model Description

The [_Vehicle Model_](/docs/concepts/development_model/#vehicle-models) of the _Vehicle App_ is described with the source and required (or optional) datapoints.
More information: [Vehicle Model Creation](/docs/tutorials/vehicle_model_creation/)

The source ("src") identifies the used _Vehicle Model_ description and the data points section defines which signals (i.e. data points) of that model need to be available for the _Vehicle App_ to run:

- The `path` references the definition (type, data type, unit, and other metadata) of a data point in the specified model
- The `required` flag tells if that data point is mandatory for the app to run or just optional
- `access` defines the required access right of the app to that data point (see below)

Further information can be found here: [How to Reference a Model Specification](/docs/tutorials/vehicle_model_creation/automated_model_lifecycle/#how-to-reference-a-model-specification)
</br>

### Datapoint Access Rights

{{<table "table table-bordered">}}
| Access Right | Description                                                                                                                                                 | Vehicle Databroker Interface |
|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| read         | app needs to read the value of the datapoint from the provider (e.g. get value from databroker).                                                          | GetDatapoints/Subscribe      |
| write        | app needs to get and set the value of the datapoint (e.g. set, set_many values via the databroker or services). WRITE access implicitly has READ access. | SetDatapoints                |
{{</table>}}

## AppManifest Examples

{{< tabpane lang="json">}}
{{< tab "Runtime interface via databroker" >}}

// Here we have a dependency to the databroker, the App doesn't have any direct
// connection to the SeatService because the databroker forwards the set requests from
// the app via SetDatapoints to the corresponding SeatService

{
    "name": "SeatAdjuster",
    "vehicleModel": {
        "src": "./app/vehiclemodel/used_vss.json",
        "datapoints": [
            {
                "path": "Vehicle.Cabin.Seat.Row1.Pos1.Position",
                "required": "true",
                "access": "write"
            },
            {
                "path": "Vehicle.Speed",
                "required": "true",
                 "access": "read"
            }
        ],
    },
    "runtime": [
        "grpc://sdv.databroker.v1.Broker/GetDatapoints",
        "grpc://sdv.databroker.v1.Broker/Subscribe",
        "grpc://sdv.databroker.v1.Broker/SetDatapoints",
        "mqtt"
    ]
}
{{< /tab >}}
{{< tab "Runtime interface via specific service" >}}

// Here the app establishes a direct gRPC connection to the
// Vehicle SeatService and adjusts the seat position via
// the MoveComponent Interface

{
    "name": "SeatAdjuster",
    "vehicleModel": {
        "src": "./app/vehiclemodel/used_vss.json",
        "datapoints": [
            {
                "path": "Vehicle.Cabin.Seat.Row1.Pos1.Position",
                "required": "true",
                "access": "write"
            },
            {
                "path": "Vehicle.Speed",
                "required": "true",
                 "access": "read"
            }
        ],
    },
    "runtime": [
        "grpc://sdv.databroker.v1.Broker/GetDatapoints",
        "grpc://sdv.databroker.v1.Broker/Subscribe",
        "grpc://sdv.edge.comfort.seats.v1.Seats/MoveComponent"
        "mqtt"
    ]
}
{{< /tab >}}
{{< /tabpane >}}

## Further information

- Tutorial: [Setup and Explore Development Enviroment](/docs/tutorials/setup_and_explore_development_environment.md)
- Tutorial: [Vehicle Model Creation](/docs/tutorials/vehicle_model_creation)
- Tutorial: [Vehicle App Development](/docs/tutorials/vehicle-app-development)
- Concept: [Lifecycle Management](/docs/concepts/lifecycle_management)
