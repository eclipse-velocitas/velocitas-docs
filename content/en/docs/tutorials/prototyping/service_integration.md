---
title: "Service Integration"
date: 2022-11-02T10:09:25+05:30
weight: 3
description: >
  Learn how to integrate a Vehicle Service that executes the request on vehicle side
---

Services can make sure, that when you write a VSS datapoint, something is actually happening. Eclipse Velocitas has an example seat, hvac or light service. If your _Vehicle App_ makes use of e.g. `Vehicle.Cabin.Seat.Row1.Pos1.Position`, `Vehicle.Body.Lights.IsBackupOn`, `Vehicle.Body.Lights.IsHighBeamOn`, `Vehicle.Body.Lights.IsLowBeamOn` you are in for some real action. To learn more, visit [_Vehicle Services_]({{< ref "/docs/about/development_model/val/#vehicle-services" >}}).

You can validate the interaction of the service with your _Vehicle App_ by adding a _Vehicle Service_ to the `/app/AppManifest.json`, [start the services]({{< ref "/docs/tutorials/quickstart/#starting-runtime-services" >}}) locally and [debug]({{< ref "/docs/tutorials/quickstart/#debugging-vehicle-app" >}}) it.

### Modify services

For more advanced usage you can als try modifying existing services. Check out [the seat service](https://github.com/boschglobal/kuksa.val.services/tree/feature/subscribe_actuator_targets/seat_service) for example, modify it and integrate it into your _Vehicle App_ repository.

### Create your own services

If you want to create your own service the [KUKSA.val Services repository](https://github.com/eclipse/kuksa.val.services/) contains examples illustrating how such kind of vehicle services can be built. You need to write an application that talks to _KUKSA.val_ listening to changes of a _target value_ of some VSS datapoint and then do whatever you want. You can achieve this by using the _KUKSA.val_ [GRPC API](https://github.com/eclipse/kuksa.val/tree/master/proto/kuksa/val/v1) with any programming language of your choice (learn more about [GRPC](https://grpc.io)).
