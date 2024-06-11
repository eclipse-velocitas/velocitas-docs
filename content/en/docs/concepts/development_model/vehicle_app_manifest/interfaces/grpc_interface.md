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
| Attribute | Type | Example value | Description |
|-|-|-|-|
| `src` | string | `"https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto"` | URI of the used protobuf specification of the service. URI may point to a local file or to a file provided by a server. It is generally recommended that a **stable** proto file is used. I.e. one that is already released under a proper tag rather than an in-development proto file. |
| `required.methods` | array | Array of service's methods that are accessed by the application. In addition to access control the methods attribute may be used to determine backward or forward compatibility i.e. if semantics of a service's interface did not change but methods were added or removed in a future version. |
| `required.methods.[].name` | string | `"Move"`, `"MoveComponent"` | Name of the method that the application would like to access |
| `provided` | object | `{}` | Reserved object indicating that the interface is provided. Might be filled with further configuration values.
{{</table>}}

## Execution
`velocitas init`
**or**
`velocitas exec grpc-interface-support generate-sdk`

## Project configuration
```json
{
  "type": "grpc-interface",
  "config": {
      "src": "https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto",
      "required": {
        "methods": [
          "Move", "MoveComponent"
        ]
      },
      "provided": { }
  }
}
```

You need to specify `devenv-devcontainer-setup` >= `v2.4.2` in your project configuration. Therefore your `.veloitas.json` should look similair to this example:

```json
{
  "packages": {
    "devenv-devcontainer-setup": "v2.4.2"
  },
  "components": [
    {
      "id": "grpc-interface-support", 
    }
  ],
}
```

To do that you can run `velocitas component add grpc-interface-support` when your package is above or equal to v2.4.2
