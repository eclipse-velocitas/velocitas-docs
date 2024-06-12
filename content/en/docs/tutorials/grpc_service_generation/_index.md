---
title: "gRPC service generation"
date: 2024-06-07T14:02:00+05:30
weight: 60
description: >
  Learn how to generate and fill your own gRPC services.
---

This tutorial shows how to generate a basic gRPC service like a seat service. For this example the proto file under <https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto> is taken.

All files included from `services/seats` are auto-generated and added to the app project as Conan dependency.
For writing a complete gRPC service you need two velocitas apps/projects.
One is implementing a client and the other one is for providing the server.
To complete the server implementation you have to fill the generated `*ServiceImpl.cpp`.
Have a look at the linked content beneath for a tutorial how it would be done for a SeatService leveraging <https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto>.

To run the example you need to start the velocitas app for the server first and then the second velocitas app for the client.
