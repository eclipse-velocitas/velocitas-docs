---
title: "gRPC Interface"
date: 2023-08-09T00:00:00+01:00
weight: 30
description: >
  The logical interface for supporting remote procedure calls via gRPC.

---

## Interface type key: `grpc-interface`

## Description

This interface type introduces a dependency to a gRPC service. It is used to generate either client stubs (in case your application requires the interface) or server stubs (in case your application provides the interface). The result of the generation is a language specific and package manager specific source code package, integrated with the Velocitas SDK core.

## Configuration structure

{{<table "table table-bordered">}}
| Attribute | Example value | Description |
|-|-|-|
| `src` | `"https://raw.githubusercontent.com/eclipse/kuksa.val.services/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto"` | URI of the used protobuf specification of the service. URI may point to a local file or to a file provided by a server. |
| `methods` | | Array of service's methods that are accessed by the application. |
| `methods.[].name` | | Name of the method that the application would like to access |
{{</table>}}
