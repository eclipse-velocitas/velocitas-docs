---
title: "Manual Vehicle Model Creation"
date: 2022-05-09T13:43:25+05:30
weight: 20
description: >
  Learn how to manually create a vehicle model to access vehicle data or execute remote procedure calls.
---

{{% alert title="Info" %}} With the release of our new [model lifecycle approach](../automated_model_lifecycle) on Friday, 2023-03-03, the model is now automatically generated with the instantiation of the devContainer from a model source referenced in the app manifest.

The approach described here, using pre-generated model repositories, is deprecated as of now. But it is still available and must be used if you need access to vehicle services. Please be aware, that you would either have to use template versions before the above mentioned release, or you need to adapt the newer versions of the template using the old approach.
{{% /alert %}}

This tutorial will show you how to:

- Create a _Vehicle Model_
- Add a _Vehicle Service_ to the _Vehicle Model_
- Distribute your Python Vehicle Model

{{% alert title="Note" %}}
A _Vehicle Model_ should be defined in its own package. This makes it possible to distribute the _Vehicle Model_ later as a standalone package and to use it in different _Vehicle App_ projects.

The creation of a new vehicle model is only required if the vehicle signals (like sensors and actuators) defined in the current version of the [COVESA Vehicle Signal Specification](https://covesa.github.io/vehicle_signal_specification/) (VSS) is not sufficient for the definition of your vehicle API. Otherwise you could use the default vehicle model we already generated for you, see [Python Vehicle Model](https://github.com/eclipse-velocitas/vehicle-model-python) and [C++ Vehicle Model](https://github.com/eclipse-velocitas/vehicle-model-cpp).  
{{% /alert %}}

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
  5. Now the newly generated `sdv_model` can be used for distribution. (See [Distributing your Vehicle Model](vehicle_model_distribution))

## Create a Vehicle Model Manually

Alternative to the generation from a VSS specification you could create the _Vehicle Model_ manually. The following sections describing the required steps.

- [Python]({{< ref "manual_creation_python.md" >}})

## Distributing your Vehicle Model

Once you have created your Vehicle Model either manually or via the Vehicle Model Generator, you need to distribute your model to use it in an application. Follow the links below for language specific tutorials on how to distribute your freshly created Vehicle Model.

- [Python](vehicle_model_distribution/distribution_python)
- [C++](vehicle_model_distribution/distribution_cpp)

## Further information

- Concept: [SDK Overview](/docs/concepts/vehicle_app_sdk_overview.md)
- Tutorial: [Setup and Explore Development Enviroment](/docs/tutorials/quickstart)
- Tutorial: [Create a Vehicle App](/docs/tutorials/vehicle-app-development)
