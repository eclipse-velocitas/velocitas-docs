---
title: "gRPC service generation"
date: 2024-06-07T14:02:00+05:30
weight: 60
description: >
  Learn how to generate and fill your own gRPC services.
---

This tutorial shows how to generate a basic gRPC service like a seat service. For this example the proto file at <https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/0.4.0/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto> is used.

All files included from `services/seats` are auto-generated and added to the app project as Conan dependency.
For writing a complete gRPC service you need two velocitas apps/projects.
One is implementing a client and the other one is for providing the server.

## Networking

The examples shown in this tutorial are based on three components running:

* A client using the API defined in the proto file
* A server providing the API and communicating with Databroker to read or modify datapoints
* A [Kuksa Databroker](https://github.com/eclipse-kuksa/kuksa-databroker).

As a Velocitas developer you may use the [Velocitas devenv-runtimes](https://github.com/eclipse-velocitas/devenv-runtimes) to deploy and run the Databroker instance, but it is also possible to connect to a Databroker running on localhost.
The following setup was used for the examples:

* One Velocitas Devcontainer running the Client, based on the [Vehicle App C++ Template](https://github.com/eclipse-velocitas/vehicle-app-cpp-template).
* One Velocitas Devcontainer running the Server, based on the [Vehicle App C++ Template](https://github.com/eclipse-velocitas/vehicle-app-cpp-template).
* Databroker running on localhost.

For this to work the `.devcontainer/devcontainer.json` was changed.
In the setup `--network=host` was added to allow the containers to use the host network.
For the server `forwardPorts": [ 5555 ]` was additionally used to forward port 5555.

```
    "forwardPorts": [ 5555 ],
	"runArgs": [
		"--init",
		"--privileged",
		"--cap-add=SYS_PTRACE",
		"--network=host",
		"--security-opt",
		"seccomp=unconfined"
	],
```

Note that changes to `.devcontainer/devcontainer.json` may be overwritten when `velocitas sync` is performed.

## Running the examples

To run the examples the following actions need to be performed in the shown order:

* Databroker needs to be started.
  If using a Databroker on host, make sure that it is compatible with the Velocitas version you are using.
  The catalog used must also be compatible with the signals used in the example.
* Set the current value of `Vehicle.Cabin.Seat.Row1.DriverSide.Position` to a valid value, for example 12, using a Databroker Client ([Kuksa Python Client](https://pypi.org/project/kuksa-client/) or [Databroker CLI](https://github.com/eclipse-kuksa/kuksa-databroker)).
* Start the server.
* Start the client.
* Verify that no (unexpected) errors are reported.
* Use the Databroker Client to verify that the target value of `Vehicle.Cabin.Seat.Row1.DriverSide.Position` has been set to 75.
