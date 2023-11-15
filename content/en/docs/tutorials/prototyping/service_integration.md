---
title: "Service Integration"
date: 2022-11-02T10:09:25+05:30
weight: 3
description: >
  Learn how to integrate a _Vehicle Service_ that executes the request of your _Vehicle App_ on vehicle side
---

Services can make sure, that when you write a VSS data point, something is actually happening. Eclipse Velocitas has an example seat or hvac service. If your _Vehicle App_ makes use of e.g. `Vehicle.Cabin.Seat.Row1.Pos1.Position` or other seat/hvac specific data points you are in for some real action. To learn more, visit [_Vehicle Services_](/docs/concepts/development_model/val/#vehicle-services).

Our maintained [`devenv-runtimes`](https://github.com/eclipse-velocitas/devenv-runtimes) package ([Velocitas Lifecycle Management](/docs/concepts/lifecycle_management)) comes with the support of adding further _Vehicle Services_ to the `runtime.json` of a package. More information [here](/docs/concepts/lifecycle_management/packages/development/#configuration-of-runtime-packages). (A general vehicle _mock service_ is also coming soon!)

### Modify existing services

For more advanced usage you can also try to modify existing services. Check out [the seat service](https://github.com/eclipse/kuksa.val.services/tree/main/seat_service) for example, modify it and integrate it into your _Vehicle App_ repository.

### Create your own services

If you want to create your own service the [KUKSA.VAL Services repository](https://github.com/eclipse/kuksa.val.services/) contains examples illustrating how such kind of vehicle services can be built. You need to write an application that talks to _KUKSA.VAL_ listening to changes of a _target value_ of some VSS data point and then do whatever you want. You can achieve this by using the _KUKSA.VAL_ [gRPC API](https://github.com/eclipse/kuksa.val/tree/master/proto/kuksa/val/v1) with any programming language of your choice (learn more about [gRPC](https://grpc.io)).

### Mock Service and Mock Service Integration

[The Vehicle Mock Service](https://github.com/eclipse/kuksa.val.services/tree/main/mock_service) is a dummy service allowing to control all specified actuator- and sensor-signals via a configuration file. These configuration files are expressed in a Python-based domain-specific language (DSL).
The default behavior is predefined in [mock.py](https://github.com/eclipse/kuksa.val.services/blob/main/mock_service/mock.py)

The Mock Service is already integrated in all our [Vehicle Runtimes](/docs/tutorials/vehicle_app_runtime). To be able to configure it, you need to add a custom `mock.py` in the root of your Vehicle App Project. The Mock Service Container will pick it up automatically.
