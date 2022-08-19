---
title: "Vehicle Model Creation"
date: 2022-05-09T13:43:25+05:30
weight: 1
description: >
  Learn how to create a Vehicle Model to access vehicle data or execute remote procedure calls.
aliases:
  - /docs/tutorials/tutorial_how_to_create_a_vehicle_model.md
---

A _Vehicle Model_ makes it possible to easily get vehicle data from the KUKSA Data Broker and to execute remote procedure calls over gRPC against _Vehicle Services_ and other _Vehicle Apps_. It is generated from the underlying semantic models for a concrete programming language as a graph-based, strongly-typed, intellisense-enabled library. 

This tutorial will show you how to:

- Create a _Vehicle Model_
- Add a _Vehicle Service_ to the _Vehicle Model_
- Distribute your Python Vehicle Model

{{% alert title="Note" %}}
A _Vehicle Model_ should be defined in its own package. This makes it possible to distribute the _Vehicle Model_ later as a standalone package and to use it in different _Vehicle App_ projects.
{{% /alert %}}

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) with the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) installed. For information on how to install extensions on Visual Studio Code, see [VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery).

## Create a Vehicle Model from VSS specification

A _Vehicle Model_ can be generated from a [COVESA Vehicle Signal Specification](https://covesa.github.io/vehicle_signal_specification/) (VSS). VSS introduces a domain taxonomy for vehicle signals, in the sense of classical attributes, sensors and actuators with the raw data communicated over vehicle buses and data. The Velocitas [vehicle-model-generator](https://github.com/eclipse-velocitas/vehicle-model-generator) creates a _Vehicle Model_ from the given specification and generates a package for use in _Vehicle App_ projects.

Follow the steps to generate a _Vehicle Model_.

  1. Clone the [vehicle-model-generator](https://github.com/eclipse-velocitas/vehicle-model-generator) repository in a container volume.

  2. In this container volume, clone the [vehicle-signal-specification](https://github.com/COVESA/vehicle_signal_specification) repository and if required checkout a particular branch:

        ```bash
        git clone https://github.com/COVESA/vehicle_signal_specification

        cd vehicle_signal_specification
        git checkout <branch-name>
        ```

        In case the VSS vspec doesn't contain the required signals, you can create a vspec using the [VSS Rule Set](https://covesa.github.io/vehicle_signal_specification/rule_set/).

  3. Execute the command

        ```bash
        python3 gen_vehicle_model.py -I ./vehicle_signal_specification/spec ./vehicle_signal_specification/spec/VehicleSignalSpecification.vspec -l <lang> -T sdv_model -N sdv_model
        ```

        Depending on the value of `lang`, which can assume the values `python` and `cpp`, this creates a `sdv_model` directory in the root of repository along with all generated source files for the given programming language.

        Here is an overview of what is generated for every available value of `lang`:

        | lang       | output                                                                          |
        | :--------- |:------------------------------------------------------------------------------- |
        | `python`   | python sources and a `setup.py` ready to be used as python package              |
        | `cpp`      | c++ sources, headers and a CMakeLists.txt ready to be used as a CMake project   |

        To have a custom model name, refer to README of [vehicle-model-generator](https://github.com/eclipse-velocitas/vehicle-model-generator) repository.
  4. For python: Change the version of package in `setup.py` manually (defaults to 0.1.0).
  5. Now the newly generated `sdv_model` can be used for distribution. (See [Distributing your Vehicle Model](/docs/tutorials/vehicle_model_distribution))

## Create a Vehicle Model Manually

Alternative to the generation from a VSS specification you could create the _Vehicle Model_ manually. The following sections describing the required steps.

- [Python]({{< ref "manual_creation_python.md" >}})

## Distributing your Vehicle Model

Once you have created your Vehicle Model either manually or via the Vehicle Model Generator, you need to distribute your model to use it in an application. Follow the links below for language specific tutorials on how to distribute your freshly created Vehicle Model.

- [Python]/docs/tutorials/how_to_create_a_vehicle_model/distribution_python.md)
- [C++](/docs/tutorials/how_to_create_a_vehicle_model/distribution_cpp.md)

## Further information

- Concept: [SDK Overview](/docs/concepts/vehicle_app_sdk_overview.md)
- Tutorial: [Setup and Explore Development Enviroment](/docs/tutorials/quickstart)
- Tutorial: [Create a Vehicle App]({{< ref "/docs/tutorials/vehicle-app-development" >}})
