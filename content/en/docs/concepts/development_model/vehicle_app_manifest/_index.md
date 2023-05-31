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

The concept of the so called _AppManifest_ is to provide flexibility of splitting _Vehicle App_ requirements and dependencies from _Runtime_ and _Middleware_ requirements in order to provide independent and structured configurations for every component.

The AppManifest is the only source of truth in our _Vehicle App_ templates for:

- Local development environments and configs
- deployment specs generation
- Velocitas CI/CD workflow
- OCI Image creation

## Purpose

- The AppManifest contains necessary information about required Vehicle Runtime (Services, Environment Variables, VehicleModel)
- The AppManifest contains all required (or optional) Datapoints that are used in the _Vehicle App_ with the necessary access rights (read, write)
- The AppManifest is service provider/implementation agnostic, while the service configurations are part of a corresponding [Velocitas Lifecycle Management](/docs/concepts/lifecycle_management) runtime package.

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
</br>
The source identifies the used _Vehicle Model_ description and the datapoints section defines which signals need to be available for the _Vehicle App_ to run with the path, required flag and access rights.
</br>
More to read: [How to Reference a Model Specification](/docs/tutorials/vehicle_model_creation/automated_model_lifecycle/#how-to-reference-a-model-specification)
</br>

### Datapoint Access Rights

{{<table "table table-bordered">}}
| Access Right | Description                                                                                                                                                 | Vehicle Databroker Interface |
|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| read         | app needs to access the value of the datapoint from the provider (e.g. get value from databroker).                                                          | GetDatapoints/Subscribe      |
| write        | app needs to access and set the value of the datapoint (e.g. set, set_many values via the databroker or services). WRITE access implicitly has READ access. | SetDatapoints                |
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
