---
title: "Vehicle Abstraction Layer (VAL)"
date: 2022-05-09T14:24:56+05:30
weight: 20
resources:
- src: "**dataflow_broker*.png"
- src: "**dataflow_service*.png"
- src: "**val_architecture*.png"
- src: "**val_overview*.drawio.svg"
description: >
  Learn about the main concepts and components of the vehicle abstraction and how it relates to the [Eclipse KUKSA project](https://github.com/eclipse-kuksa).
---

## Introduction

The Vehicle Abstraction Layer (VAL) enables access to the systems and functions of a vehicle via a unified - or even better - a standardized _Vehicle API_ abstracting from the details of the end-to-end architecture of the vehicle. The unified API enables _Vehicle Apps_ to run on different vehicle architectures of a single OEM. _Vehicle Apps_ can be even implemented OEM-agnostic, if using an API based on a standard like the [COVESA Vehicle Signal Specification (VSS)](https://covesa.github.io/vehicle_signal_specification/).
The _Vehicle API_ eliminates the need to know the source, destination, and format of signals for the vehicle system.

The Eclipse Velocitas project is using the [_Eclipse KUKSA project_](https://github.com/eclipse-kuksa).
KUKSA does not provide a concrete VAL. That's up to you as an OEM (vehicle manufacturer) or as a supplier.
But KUKSA provides the components and tools that helps you to implement a VAL for your chosen end-to-end architecture. Also, it can support you to simulate the vehicle hardware during the development phase of an _Vehicle App_ or Service.

KUKSA provides you with ready-to-use generic components for the signal-based access to the vehicle, like the _KUKSA Databroker_ and the generic _Data Providers_ (aka _Data Feeders_).
It also provides you reference implementations of certain _Vehicle Services_, like the _Seat Service_ and the _HVAC Service_.

## Architecture

The image below shows the main components of the VAL and its relation to the [Velocitas Development Model](/docs/concepts/development_model.md).

![Overview of the VAL architecture](./val_overview.drawio.svg)

### KUKSA Databroker

The [KUKSA Databroker](https://github.com/eclipse-kuksa/kuksa-databroker) is a gRPC service acting as a broker of vehicle data / signals also called _data points_ in the following.
It provides central access to vehicle data points arranged in a - preferably standardized - vehicle data model like the COVESA VSS or others. But this is not a must, it is also possible to use your own (proprietary) vehicle model or to extend the COVESA VSS with your specific extensions via [VSS _overlays_](https://covesa.github.io/vehicle_signal_specification/rule_set/overlay/).

Data points represent certain states of a vehicle, like the current vehicle speed or the currently applied gear. Data points can represent sensor values like the vehicle speed or engine temperature, actuators like the wiper mode, and immutable attributes of the vehicle like the needed fuel type(s) of the vehicle, engine displacement, maximum power, etc.

Data points factually belonging together are typically arranged in branches and sub-branches of a tree structure (like [this example](https://covesa.github.io/vehicle_signal_specification/introduction/overview/#example) on the COVESA VSS site).

The KUKSA Databroker is implemented in Rust, can run in a container and provides services to get data points, update data points and for subscribing to automatic notifications on data point changes.
Filter- and rule-based subscriptions of data points can be used to reduce the number of updates sent to the subscriber.

### Data Providers / Data Feeders

Conceptually, a data provider is the responsible to take care for a certain set of data points: It provides updates of sensor data from the vehicle to the Databroker and forwards updates of actuator values to the vehicle. The set of data points a data provider maintains may depend on the network interface (e.g. CAN bus) via that those data is accessible or it can depend on a certain use case the provider is responsible for (like seat control).

Eclipse KUKSA provides several _generic_ [_Data Providers_](https://github.com/eclipse-kuksa#providers-exchanging-data-with-databrokerserver) for different datasources.
As of today, Eclipse Velocitas only utilizes the generic [CAN Provider (KUKSA CAN Provider)](https://github.com/eclipse-kuksa/kuksa-can-provider) implemented in Python, which reads data from a CAN bus based on mappings specified in e.g. a CAN network description (dbc) file.
The feeder uses a mapping file and data point metadata to convert the source data to data points and injects them into the Databroker using its `Collector` gRPC interface.
The feeder automatically reconnects to the Databroker in the event that the connection is lost.

### Vehicle Services

A vehicle service offers a _Vehicle App_ to interact with the vehicle systems on a RPC-like basis.
It can provide service interfaces to control actuators or to trigger (complex) actions, or provide interfaces to get data.
It communicates with the Hardware Abstraction to execute the underlying services, but may also interact with the Databroker.

The [KUKSA Incubation repository](https://github.com/eclipse-kuksa/kuksa-incubation) contains examples illustrating how such kind of vehicle services can be built.

### Hardware Abstraction

Data feeders rely on hardware abstraction. Hardware abstraction is project/platform specific.
The reference implementation relies on **SocketCAN** and **vxcan**, see [KUKSA CAN Provider](https://github.com/eclipse-kuksa/kuksa-can-provider).
The hardware abstraction may offer replaying (e.g., CAN) data from a file (can dump file) when the respective data source (e.g., CAN) is not available.

{{< imgproc val_architecture Resize "800x" >}}
  Overview of the VAL architecture
{{< /imgproc >}}

## Information Flow

The VAL offers an information flow between vehicle networks and vehicle services.
The data that can flow is ultimately limited to the data available through the Hardware Abstraction, which is platform/project-specific.
The KUKSA Databroker offers read/subscribe access to data points based on a gRPC service. The data points which are actually available are defined by the set of feeders providing the data into the broker.
Services (like the [seat service](https://github.com/eclipse-kuksa/kuksa-incubation/tree/main/seat_service)) define which CAN signals they listen to and which CAN signals they send themselves, see [documentation](https://github.com/eclipse-kuksa/kuksa-incubation/blob/main/seat_service/src/lib/seat_adjuster/seat_controller/README.md).
Service implementations may also interact as feeders with the Databroker.

### Data flow when a _Vehicle App_ uses the KUKSA Databroker

{{< imgproc dataflow_broker Resize "800x" >}}
  Architectural representation of the KUKSA Databroker data flow
{{< /imgproc >}}

### Data flow when a _Vehicle App_ uses a Vehicle Service

{{< imgproc dataflow_service Resize "800x" >}}
  Architectural representation of the vehicle service data flow
{{< /imgproc >}}

## Source Code

Source code and build instructions are available in the respective KUKSA repositories:

* [KUKSA Databroker](https://github.com/eclipse-kuksa/kuksa-databroker)
* [KUKSA CAN Provider](https://github.com/eclipse-kuksa/kuksa-can-provider)
* [KUKSA example providers](https://github.com/eclipse-kuksa#providers-exchanging-data-with-databrokerserver)


## GRPC Interface Style Guide

A style guide is available in the [GRPC Interface Style Guide](grpc_style_guide.md)
