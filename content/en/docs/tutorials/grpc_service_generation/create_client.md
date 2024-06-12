---
title: "Create a client"
date: 2024-06-07T14:02:00+05:30
weight: 60
description: >
  Learn how to create a client for a service definition.
---


## App configuration

```json
{
  "type": "grpc-interface",
  "config": {
      "src": "https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto",
      // "required" indicates you are trying to write a client for the service
      "required": {
        "methods": [
          "Move", "CurrentPosition"
        ]
      },
  }
}
```

## Project configuration

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

## Example code

To create a client we use the generated `SeatsServiceClientFactory.h` and `seats.grpc.pb.h`. These define request and response types and the operations that are available. An example implementation for the SeatService follows:

### main.cpp

``` cpp
#include "sdk/middleware/Middleware.h"
#include <services/seats/SeatsServiceClientFactory.h>
#include <services/seats/seats.grpc.pb.h>

#include <iostream>

using namespace velocitas;

int main(int argc, char** argv) {
    auto serviceClient = SeatsServiceClientFactory::create(Middleware::getInstance());

    ::grpc::ClientContext                        context;
    ::sdv::edge::comfort::seats::v1::MoveRequest request;
    ::sdv::edge::comfort::seats::v1::MoveReply   response;

    ::sdv::edge::comfort::seats::v1::Seat seat;

    ::sdv::edge::comfort::seats::v1::SeatLocation seat_location;
    seat_location.set_row(1);
    seat_location.set_index(1);

    ::sdv::edge::comfort::seats::v1::Position seat_position;
    // we only set base here to keep the example simple
    // extend here if yu want to set lumbar etc.
    seat_position.set_base(1000);

    seat.set_allocated_location(&seat_location);
    seat.set_allocated_position(&seat_position);

    request.set_allocated_seat(&seat);

    auto status = serviceClient->Move(&context, request, &response);

    std::cout << "gRPC Server returned code: " << status.error_code() << std::endl;
    std::cout << "gRPC error message: " << status.error_message().c_str() << std::endl;

    if (status.error_code() == ::grpc::StatusCode::UNIMPLEMENTED) {
        return 1;
    } else {
        ::grpc::ClientContext                                   context;
        ::sdv::edge::comfort::seats::v1::CurrentPositionRequest request;
        ::sdv::edge::comfort::seats::v1::CurrentPositionReply   response;

        request.set_row(1);
        request.set_index(1);

        auto status_curr_pos = seatService->CurrentPosition(&context, request, &response);
        std::cout << "current Position:" << response.seat().position().base() << std::endl;
        std::cout << "gRPC Server returned code: " << status_curr_pos.error_code() << std::endl;
        std::cout << "gRPC error message: " << status_curr_pos.error_message().c_str() << std::endl;
        return 0;
    }
}
```
