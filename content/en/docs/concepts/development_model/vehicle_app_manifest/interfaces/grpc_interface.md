---
title: "gRPC Service Interface"
date: 2023-08-09T00:00:00+01:00
weight: 20
description: >
  The functional interface for supporting remote procedure calls via gRPC.

---

{{<table "table table-bordered">}}
| Providing CLI package       | Interface type-key    |
|-----------------------------|-----------------------|
| `devenv-devcontainer-setup` | `grpc-interface`      |
{{</table>}}

## Description

This interface type introduces a dependency to a gRPC service. It is used to generate either client stubs (in case your application requires the interface) or server stubs (in case your application provides the interface). The result of the generation is a language specific and package manager specific source code package, integrated with the Velocitas SDK core.

If a _Vehicle App_ requires a `grpc-interface` - a client stub embedded into the Velocitas framework will be generated and added as a build-time dependency of your application. It enables you to access your service from your _Vehicle App_ without any additional effort.

If a _Vehicle App_ provides a `grpc-interface` - a server stub embedded into the Velocitas framework will be generated and added as a build-time dependency of your application. It enables you to quickly add the business logic of your application.

## Configuration structure

{{<table "table table-bordered">}}
| Attribute | Example value | Description |
|-|-|-|
| `src` | `"https://raw.githubusercontent.com/eclipse/kuksa.val.services/v0.2.0/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto"` | URI of the used protobuf specification of the service. URI may point to a local file or to a file provided by a server. It is generally recommended that a **stable** proto file is used. I.e. one that is already released under a proper tag rather than an in-development proto file. |
| `required.methods` | | Array of service's methods that are accessed by the application. In addition to access control the methods attribute may be used to determine backward or forward compatibility i.e. if semantics of a service's interface did not change but methods were added or removed in a future version. |
| `required.methods.[].name` | `"Move"`, `"MoveComponent"` | Name of the method that the application would like to access |
| `provided.methods` | | Array of service's methods that are provided by the application. The attribute may be used to determine backward or forward compatibility i.e. if semantics of a service's interface did not change but methods were added or removed in a future version. |
| `provided.methods.[].name` | `"Move"`, `"MoveComponent"` | Name of the method that the application would like to access |
{{</table>}}

## Example

```json
{
    "type": "grpc-interface",
    "config": {
        "src": "https://raw.githubusercontent.com/eclipse/kuksa.val.services/v0.2.0/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto",
        "required": {
          "methods": [
            "Move", "MoveComponent"
          ]
        }
    }
}
```
