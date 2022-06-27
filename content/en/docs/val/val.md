---
title: "Introduction to Vehicle Abstraction Layer"
date: 2022-05-09T14:24:56+05:30
weight: 1
aliases:
  - /docs/velocitas/docs/val/README.md
---

## Introduction

The Vehicle Abstraction Layer (VAL) is a reference implementation of an abstraction layer that allows Vehicle applications
to interact with signals and services in the vehicle.
It currently consists of a data broker, a CAN feeder and a set of example services.
More elaborate or completely differing implementations are target of particular derived projects.

## Architecture

The image below shows the main components of the Vehicle Abstraction Layer (VAL) and its relation to the [Velocitas Development Model](/docs/development-model.md).

![overview](/val/assets/val_architecture_overview.png)

### Vehicle Data Broker

The [Vehicle Data Broker](https://github.com/eclipse/kuksa.val/tree/master/kuksa_databroker) is a gRPC service acting as a broker of vehicle data / data points / signals.
It provides a central access to vehicle data points arranged in a - preferably standardized - vehicle data model like the [COVESA Vehicle Signal Specification (VSS)](https://covesa.github.io/vehicle_signal_specification/) or others.
It is implemented in Rust, can run in a container and provides services to get datapoints, update datapoints and for subscribing to datapoints.
Filter- and rule-based subscriptions of datapoints can be used to reduce number of updates sent to the subscriber.

### Data Feeders

Conceptually, a data feeder is a provider of a certain set of data points to the data broker.
The source of the contents of the provided data points is specific to the respective feeder.

As of today the Vehicle Abstraction Layer contains a [generic CAN feeder](https://github.com/eclipse/kuksa.val/tree/master/kuksa_feeders) implemented in Python,
which reads data from a CAN bus based on specifications in a e.g. CAN network description file.
The feeder then uses a mapping file and data point metadata to convert the source data to data points and injects them into the Vehicle Data Broker using the Vehicle Data Broker gRPC interface.
The feeder automatically reconnects to the data broker in case connection is lost.

### Vehicle Services

A vehicle service offers a gRPC interface for interacting with underlying services.
It can provide service interfaces to control actuators or to trigger (complex) actions, or provide interfaces to get data.
It communicates with the Hardware Abstraction to execute the underlying services, but may also interact with the Vehicle Data Broker.

As of today the Vehicle Abstraction Layer contains one [example service to control a seat](https://github.com/eclipse/kuksa.val.services/tree/v0.1.0/seat_service).
It is implemented in C++ and use the [CAN feeder](https://github.com/eclipse/kuksa.val/tree/master/kuksa_feeders) to control a seat in the vehicle.

### Hardware Abstraction

Data feeders rely on hardware abstraction. Hardware abstraction project/platform specific.
The reference implementation relies on [SocketCAN][(https://github.com/eclipse/kuksa.val/tree/master/kuksa_feeders](https://github.com/eclipse/kuksa.val/tree/master/kuksa_feeders)) and
[vxcan](https://github.com/eclipse/kuksa.val/tree/master/kuksa_feeders).
The hardware abstraction may offer replaying (e.g. CAN) data from a file (can dump file) when the respective data source (e.g. CAN) is not available.

## Information Flow

The vehicle abstraction layer offers information to flow between vehicle networks and vehicle services.
The data that can flow is ultimately limited to the data available through the Hardware Abstraction which is platform/project specific.
Which data that actually can be sent or consumed is controlled by [DBC](https://github.com/eclipse/kuksa.val/blob/master/kuksa_feeders/dbc2val/Model3CAN.dbc)
and [Mapping](https://github.com/eclipse/kuksa.val/blob/master/kuksa_feeders/dbc2val/mapping.yml) files.
Services (like the [seat service](https://github.com/eclipse/kuksa.val.services/tree/v0.1.0/seat_service)) define themselves which CAN signals they listen to and which CAN signals they send, see [documentation](https://github.com/eclipse/kuksa.val.services/blob/v0.1.0/seat_service/src/lib/seat_adjuster/seat_controller/README.md)
The Vehicle Data Broker broker offers read/write/subscribe using MQTT. VSS Signals supported are currently limited by a [hard coded list](https://github.com/eclipse/kuksa.val/blob/master/kuksa_databroker/databroker/src/main.rs).

Additional information on how data privacy is managed can be found in the [Vehicle Abstraction Layer repository](https://github.com/eclipse/kuksa.val.services/tree/v0.1.0#privacy-customer-information)

### Data flow when a Vehicle Application use the Vehicle Data Broker.

![Vehicle Data Broker information flow overview ](/val/assets/dataflow_broker.png)

### Data flow when a Vehicle Application use a Vehicle Service.

![Vehicle Service information flow overview ](/val/assets/dataflow_service.png)

## Source Code

Source code and build instructions are available in the [kuksa.val repository](https://github.com/eclipse/kuksa.val).

## Guidelines

- Please see the [vehicle service guidelines](vehicle_service.md) for information on how to implement a Vehicle Service.
- Please see the [interface guideline](interface_guideline.md) for best practices on how to specify a gRPC interface.
