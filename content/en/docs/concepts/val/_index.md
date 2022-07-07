---
title: "Vehicle Abstraction Layer (VAL)"
date: 2022-05-09T14:24:56+05:30
weight: 3
resources:
- src: "**dataflow_broker*.png"
- src: "**dataflow_service*.png"
- - src: "**val_architecture_overview*.png"
---

## Introduction

The Eclipse Velocitas project is using the Vehicle Abstraction Layer (VAL) of the [Eclipse KUKSA project](https://www.eclipse.org/kuksa/), also called KUKSA.VAL.
It is is a reference implementation of an abstraction layer that allows Vehicle applications to interact with signals and services in the vehicle.
It currently consists of a data broker, a CAN feeder and a set of example services.
More elaborate or completely differing implementations are the target of particular derived projects.

## Architecture

The image below shows the main components of the Vehicle Abstraction Layer (VAL) and its relation to the [Velocitas Development Model](/docs/development-model.md).

{{< imgproc val_architecture_overview Resize "800x" >}}
  Overview of the vehicle abstraction layer architecture
{{< /imgproc >}}

### KUKSA Data Broker

The [KUKSA Data Broker](https://github.com/eclipse/kuksa.val/tree/master/kuksa_databroker) is a gRPC service acting as a broker of vehicle data / data points / signals.
It provides central access to vehicle data points arranged in a - preferably standardized - vehicle data model like the [COVESA Vehicle Signal Specification (VSS)](https://covesa.github.io/vehicle_signal_specification/) or others.
It is implemented in Rust, can run in a container and provides services to get datapoints, update datapoints and for subscribing to datapoints.
Filter- and rule-based subscriptions of datapoints can be used to reduce the number of updates sent to the subscriber.

### Data Feeders

Conceptually, a data feeder is a provider of a certain set of data points to the data broker.
The source of the contents of the data points provided is specific to the respective feeder.

As of today, the Vehicle Abstraction Layer contains a [generic CAN feeder](https://github.com/eclipse/kuksa.val/tree/main/kuksa_feeders) implemented in Python,
which reads data from a CAN bus based on specifications in a e.g., CAN network description (dbc) file.
The feeder uses a mapping file and data point metadata to convert the source data to data points and injects them into the data broker using its `Collector` gRPC interface.
The feeder automatically reconnects to the data broker in the event that the connection is lost.

### Vehicle Services

A vehicle service offers a gRPC interface allowing vehicle apps to interact with underlying services of the vehicle.
It can provide service interfaces to control actuators or to trigger (complex) actions, or provide interfaces to get data.
It communicates with the Hardware Abstraction to execute the underlying services, but may also interact with the data broker.

The KUKSA.VAL is providing examples how such kind of vehicle services could be built-up in the [kuksa.val.services repository](https://github.com/eclipse/kuksa.val.services/).

### Hardware Abstraction

Data feeders rely on hardware abstraction. Hardware abstraction is project/platform specific.
The reference implementation relies on **SocketCAN** and **vxcan**, see https://github.com/eclipse/kuksa.val.feeders/tree/main/dbc2val.
The hardware abstraction may offer replaying (e.g., CAN) data from a file (can dump file) when the respective data source (e.g., CAN) is not available.

## Information Flow

The vehicle abstraction layer offers an information flow between vehicle networks and vehicle services.
The data that can flow is ultimately limited to the data available through the Hardware Abstraction, which is platform/project-specific.
The KUKSA Data Broker offers read/subscribe access to data points based on a gRPC service. The data points which are actually available are defined by the set of feeders providing the data into the broker.
Services (like the [seat service](https://github.com/eclipse/kuksa.val.services/tree/main/seat_service)) define which CAN signals they listen to and which CAN signals they send themselves, see [documentation](https://github.com/eclipse/kuksa.val.services/blob/main/seat_service/src/lib/seat_adjuster/seat_controller/README.md).
Service implementations may also interact as feeders with the data broker.


### Data flow when a Vehicle Application uses the KUKSA Data Broker.

{{< imgproc dataflow_broker Resize "800x" >}}
  Architectural representation of the KUKSA data broker data flow
{{< /imgproc >}}

### Data flow when a Vehicle Application uses a Vehicle Service.

{{< imgproc dataflow_service Resize "800x" >}}
  Architectural representation of the vehicle service data flow
{{< /imgproc >}}

## Source Code

Source code and build instructions are available in the [kuksa.val repository](https://github.com/eclipse/kuksa.val).

## Guidelines

- Please see the [vehicle service guidelines](vehicle_service.md) for information on how to implement a Vehicle Service.
- Please see the [interface guideline](interface_guideline.md) for best practices on how to specify a gRPC interface.
