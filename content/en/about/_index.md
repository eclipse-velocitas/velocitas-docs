---
title: "About"
date: 2022-07-03T14:06:56+05:30
menu:
  main:
    weight: 1
resources:
- src: "**dev_ops_cycle*.png"
- src: "**seat_adjuster_dataflow*.png"
---

## Background

Traditionally, the automotive industry was and still is centered around vehicle hardware and the corresponding hardware development and life-cycle management. Software, however, is gaining more and more importance in vehicle development and over the entire vehicle lifetime. Thus, the vehicle and its value to the customer is increasingly defined by software. This transition towards what are termed as software-defined vehicles changes the way in which we innovate, code, deliver and work together. It is a change across the whole mobility value chain and life-cycle: from development and production to delivery and operations of the vehicle.

## Goal

The Eclipse project _Velocitas_ aims to build-up an end-to-end, scalable and modular development toolchain to create containerized in-vehicle applications (_Vehicle Apps_) that offers a comfortable, fast and efficient development experience to increase the speed of a development team.

{{< imgproc dev_ops_cycle Resize "800x" >}}
  The DevOps cycle that it followed in the design of the Velocitas programnming model
{{< /imgproc >}}

| Category                                                                                              | Description                                                                                                                                                                                                                                                                                                                   |
| ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Vehicle App Project Template](https://github.com/eclipse-velocitas/vehicle-app-python-template) | Quick setup of a _Vehicle App_ project with the help of GitHub templates for the supported programming languages including a sample _Vehicle App_ and GitHub Actions workflow, and comfortable setup of the development environment e.g. in Microsoft Visual Studio Code.                                                     |
| [Vehicle App Programming Model](/docs/development-model.md)                                           | Simplify coding and debugging of _Vehicle Apps_ that accessing vehicle data points and modifying vehicle functions using the provided SDK for the different programming languages that delegates to the _Vehicle Abstraction Layer_.                                                                                          |
| [Vehicle Abstraction Layer](docs/val/README.md)                                                       | Abstracts vehicle make & model specific properties and capabilities to a common representation. This makes it possible for _Vehicle Apps_ to be portable across different electric and electronic vehicle architectures e.g. the _Vehicle Apps_ do not care whether the seat is controlled via CAN, LIN or some other physical interface. |
| [GitHub Actions Workflow Blueprint](/docs/concepts/vehicle_app_releases/#ci-workflow-ciyml)           | Providing ready-to-use GitHub workflows to check the _Vehicle App_, build images for multi architectures, scan it, execute integration tests and release the _Vehicle App_ to allow the developer to focus on the development of the _Vehicle App_.                                                                           |
| [Automated Release Process](/docs/concepts/vehicle_app_releases/#release-workflow-releaseyml)         | Providing a release workflow to generate release artifacts and documentation out of the CI workflow results and push it to a container registry to be used by a deployment system                                                                                                                                             |
| [Runtime and Deployment Model](docs/runtime-deployment-model.md)                                      | Running and deploying _Vehicle App_ as OCI-compliant container to increase the flexibility to support different programming languages and runtimes to accelerate innovation and development.                                                                                                                              |

The repositories of the Eclipse project _Velocitas_ and their relations between each other can be found [[here](docs/repository_overview.md)].

## Example Use Case

_Velocitas_ contains implementations based on the example use case of adjusting the vehicle seat position to showcase the development toolchain of a comfort function (QM level - non-safety relevant).

What could such a use case look like? Image a carsharing company that wants to offer its customers the functionality that the driver seat automatically moves to the right position, when the driver enters the rented car. The carsharing company knows the driver and has stored the preferred seat position of the driver in its driver profile. The car gets unlocked by the driver and a request for the preferred seat position of the driver will be sent to the vehicle.

That's where your implementation starts. The _Seat Adjuster VehicleApp_ receives the seat position as a MQTT message and triggers a seat adjustment command of the _Seat Service_ that changes the seat position. Of course, the driver of a rented car would like the position, that he may have set himself, to be saved by the carsharing company and used for the next trip. As a result, the _Seat Adjuster VehicleApp_ subscribes to the seat position and receives the new seat position from the _Vehicle Data Broker_ that streams the data from the _Seat Service_.

A detailed description of the _Seat Adjuster_ use case can be found [here](docs/seat_adjuster_use_case.md).


{{< imgproc seat_adjuster_dataflow Resize "800x" >}}
  Architectural representation of the data flow on the example of adjusting the seat position     
{{< /imgproc >}}

## References

- [Vehicle Signal Specifications (VSS)](https://github.com/COVESA/vehicle_signal_specification)
