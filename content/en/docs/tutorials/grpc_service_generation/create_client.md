---
title: "Create a client"
date: 2024-06-07T14:02:00+05:30
weight: 60
description: >
  Learn how to create a client for a service definition.
---

# Introduction

This example assumes that you have used the [Velocitas App C++ Template](https://github.com/eclipse-velocitas/vehicle-app-cpp-template) to create a new repository and now want to modify it to be a grpc service client.
The example files can also be found in the [Vehicle App C++ SDK Github repository](https://github.com/eclipse-velocitas/vehicle-app-cpp-sdk/tree/main/examples/grpc_client).

# Velocitas components

Depending on how you intend to deploy the Application and Databroker the number of Velocitas components required varies.
Below is the minimum set needed in `.velocitas.json` if deploying Databroker on localhost.

```json
    "components": [
        "devcontainer-setup",
        "grpc-interface-support",
        "sdk-installer",
        "build-system"
    ],
```

## App configuration

In the `AppManifest.json` file you need to specify which interfaces your App wants to use.
In this case it declares that it wants to use `Move` and `CurrentPosition` from the Seats service defined in `seats.proto`.


```json
{
    "manifestVersion": "v3",
    "name": "SampleApp",
    "interfaces": [
        {
            "type": "grpc-interface",
            "config": {
                "src": "https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/0.4.0/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto",
                "required": {
                    "methods": [
                        "Move", "CurrentPosition"
                    ]
                }
            }
        }
    ]
}
```

## File Generation

When rebuilding the devcontainer with the configuration no new files will appear in your repository, but the SDK has been updated in the background so you can use it in the file containing `main()`.
You can also regenerate the SDK with the `(Re-)generate gRPC SDKs` task.

## Launcher.cpp

You need to have a file that implements the client behavior.
In this example we modify the file `Launcher.cpp` that already exists in the [template](https://github.com/eclipse-velocitas/vehicle-app-cpp-template).
The logic of the example client is simple. It tries to set the target position for the seat and if it succeeds it tries to read current position.

``` cpp
#include <sdk/middleware/Middleware.h>
#include <services/seats/SeatsServiceClientFactory.h>
#include <services/seats/seats.grpc.pb.h>

#include <iostream>

using namespace velocitas;

int main(int argc, char** argv) {
    // The default Velocitas Middleware class performs service discovery by
    // environment variables.
    // For this client it expects SDV_SEATS_ADDRESS to be defined
    // for example:
    // export SDV_SEATS_ADDRESS=grpc://127.0.0.1:5556

    std::cout << "Starting " << std::endl;
    auto serviceClient = SeatsServiceClientFactory::create(Middleware::getInstance());

    ::grpc::ClientContext                        context;
    ::sdv::edge::comfort::seats::v1::MoveRequest request;
    ::sdv::edge::comfort::seats::v1::MoveReply   response;

    ::sdv::edge::comfort::seats::v1::Seat seat;

    ::sdv::edge::comfort::seats::v1::SeatLocation seat_location;
    seat_location.set_row(1);
    seat_location.set_index(1);

    ::sdv::edge::comfort::seats::v1::Position seat_position;

    seat_position.set_base(75.0);

    seat.set_allocated_location(&seat_location);
    seat.set_allocated_position(&seat_position);

    request.set_allocated_seat(&seat);

    auto status = serviceClient->Move(&context, request, &response);

    std::cout << "gRPC Server returned code: " << status.error_code() << std::endl;
    std::cout << "gRPC error message: " << status.error_message().c_str() << std::endl;

    if (status.error_code() != ::grpc::StatusCode::OK) {
        // Some error
        return 1;
    } else {
        ::grpc::ClientContext                                   context;
        ::sdv::edge::comfort::seats::v1::CurrentPositionRequest request;
        ::sdv::edge::comfort::seats::v1::CurrentPositionReply   response;

        request.set_row(1);
        request.set_index(1);

        auto status_curr_pos = serviceClient->CurrentPosition(&context, request, &response);
        std::cout << "gRPC Server returned code: " << status_curr_pos.error_code() << std::endl;
        std::cout << "gRPC error message: " << status_curr_pos.error_message().c_str() << std::endl;
        if (status_curr_pos.ok())
            std::cout << "current Position:" << response.seat().position().base() << std::endl;
        return 0;
    }
}
```

## Building and Running

To (re-)build the App after changing the code you can use the [build script](https://github.com/eclipse-velocitas/vehicle-app-cpp-template/blob/main/build.sh).
As preparation for running the client you must also set an environment variable to define the address/port of the server.
The environment variable needs to be set in the same terminal as used for starting the application.

```bash
./build.sh
export SDV_SEATS_ADDRESS=grpc://127.0.0.1:5555
```

If Databroker and the Server are running and have a valid value for the wanted signal, everything should work when the client is started.
Output similar to below is expected.

```bash
vscode ➜ /workspaces/erik_vapp_241018 (main) $ build/bin/app
Starting
gRPC Server returned code: 0
gRPC error message:
gRPC Server returned code: 0
gRPC error message:
```
