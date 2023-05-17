---
title: "Vehicle Mock"
date: 2023-02-13T00:00:00+01:00
weight: 20
description: >
  Concept for mocking of vehicle data.
resources:
---

## Introduction

As VApp developer I want to have a mock environment where all VSS data points are available and in which actuators will respond when they are requested to change their value.

**Ideally, I should not care about data point availability during development time.**

## Scope

The scope of the Vehicle Mock is a CLI application without a GUI and without phyiscal simulation. It shall be usable to

* configure the mock with expected actuator and sensor behavior to develop an application against
* configure the mock with actions and reactions to use for integration tests

## Functional requirements

1. Vehicle Mock shall connect to *Kuksa Data Broker* via gRPC and act as a data feeder.
2. Vehicle Mock shall be able to accept external configuration for each data point that it is supposed to mock (= mocked data point).
3. Mocked data points shall be programmable with predefined behaviors via configuration.
4. Mocked data points shall be initializeable with a predefined value via configuration.
5. A single mocked data point shall be configurable by its exact path (i.e. `Vehicle.Cabin.Seat.Row1.Pos1.Position`)
6. A collection of mocked data points shall be configurable by specifing the wild card `*` at a specific sub-branch (i.e. `Vehicle.Cabin.Seat.*`)
7. Vehicle Mock shall be able to execute predefined behaviors once a certain condition is met:
   1. a condition evaluates to true
   2. an event is received from *Kuksa Data Broker*
8. Vehicle Mock shall be able to respond to `actuator_target` requests for all mocked data points.
   1. `actuator_target` requests shall either be fed back immediately or, if a predefined behavior for the actuator is available, that behavior shall be executed instead.
9. Behaviors shall be able to do the following for 1 to many data points:
   1. set
      1. a value
      2. continuously set a value from pre-defined list
   2. animate (for continuous data types only)
      1. to a target value
10. Animations shall support the following modes
    1. interpolation
       1. linear
       2. cubic
    2. replay (loop)
       1. non-looping
       2. reset after play, play again
       3. ping-pong (reverse play)
11. Values in behavior conditions and target values shall support liteals to indicate the use of dynamic values: `$requested_value` for the requested value of an `actuator_target` event, `$Vehicle.Speed` for dynamic evaluation of the Vehicle's current speed. All VSS sensors and actuators shall be supported in the evaluation of dynamic values.
12. It shall be possible to re-load the configuration file at runtime

## Non-funtional requirements

1. External configuration shall be as human readable as possible
2. No GUI is required

## Concept

### Flow

```mermaid
flowchart LR
    ConfigFile[(Config File)]
    ConfigFile-. 2. list of mocked datapoints .->VehicleMock
    DataBroker-. 4. actuator_target request .->VehicleMock
    VehicleMock-. 3. subscribe mocked datapoints .->DataBroker
    VehicleMock-. 1. read .->ConfigFile
    VehicleMock-. 5. feed datapoint value .->DataBroker
    VehicleMock-. 6. execute behaviors .-> VehicleMock
```

### External Configuration

The vehicle mock is mainly driven by this configuration file. Anyone shall be able to express a wide range sensor and actuator behaviors without in-depth programming knowledge.

Therefore, we want the configuration to be as human readable as possible.

For a human readable configuration whe choose YAML. JSON has too many braces and quotes, TOML does not require nesting of inner elements and nested elements have to be prefixed, making it unintuitive to read for humans.

Suggested approach: Making the datapoint configuration read as prose text but still keeping all formalities of the markup.

#### Example 1

Prose:

```text
I want to mock the datapoint at path Vehicle.Speed to always return 80
```

Markup:

```yaml
mock_datapoints:
    - at_path: Vehicle.Speed
      initialize_with: 80
```

#### Example 2

Prose:

```text
I want to mock the datapoint at path Vehicle.Cabin.Seat.Row1.Pos1.Position to animate between the current value and the requested actuator_target when an actuator target event is received
```

Markup:

```yaml
mock_datapoints:
    - at_path: Vehicle.Cabin.Seat.Row1.Pos1.Position
      behaviors:
        - if:
            event_received: actuator_target
          then:
            animate:
               to: $requested_value
```

#### Example 3

Prose:

```text
I want to mock the datapoint at path Vehicle.Body.Windshield.Front.Wiping.System.IsWiping to set it to true in case Vehicle.Body.Windshield.Front.Wiping.System.Mode is set to WIPE and Vehicle.Body.Windshield.Front.Wiping.System.ActualPosition does not equal Vehicle.Body.Windshield.Front.Wiping.System.TargetPosition.
```

Markup:

```yaml
mock_datapoints:
    - at_path: Vehicle.Body.Windshield.Front.Wiping.System.IsWiping
      behaviors:
        - if:
            all_true:
                - datapoint: Vehicle.Body.Windshield.Front.Wiping.System.Mode
                  equals: WIPE
                - datapoint: Vehicle.Body.Windshield.Front.Wiping.System.ActualPosition
                  equals: $Vehicle.Body.Windshield.Front.Wiping.System.TargetPosition
          then:
            set: true
        - else:
            set: false

```

### Class Diagarm

```mermaid
classDiagram
    class BaseService {
        Basic service responsible for 
        establishing connection to 
        Dapr sidecar and VDB.
        + connectToDatabroker()
    }

    class MockService {
        Mock service implementation which
        is responsible to load, manage and
        tick all mocked data points.
        + loadMockedDatapoints()
        + tick()
    }

    class Behavior {
        A single behavior which consists of a 
        single condition and multiple actions
        + tick() 
    }

    class Action {
        An executable action once a
        condition evaluates to true.
        + execute()
    }

    class Condition {
        Base class for conditions.
        + evaluate(): bool
    }

    class BehaviorManager {
        Manages all loaded behaviors.
        + tick()
    }

    BaseService <|-- MockService
    MockService *-- BehaviorManager
    BehaviorManager "1" *-- "1..n" Behavior
    Behavior *-- Condition
    Behavior *-- "1..n" Action
```
