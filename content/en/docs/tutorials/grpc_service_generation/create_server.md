---
title: "Create a server"
date: 2024-06-07T14:02:00+05:30
weight: 60
description: >
  Learn how to create a server for a service definition.
---


## App configuration

```json
{
  "type": "grpc-interface",
  "config": {
      "src": "https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto",
      // "provided" indicates you want to implement the server business logic for the service
      "provided": { }
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

To create a server that is providing the gRPC service we are leveraging the generated `SeatsServiceImpl.h` and `SeatsServiceServerFactory.h`. The `SeatsServiceImpl.cpp` needs to be filled with the actual implementation of the service. A quick example for a SeatService is described in the following:

### main.cpp

``` cpp
#include "sdk/middleware/Middleware.h"
#include "services/seats/SeatsServiceServerFactory.h"
#include "SeatsServiceImpl.h"

#include <memory>

using namespace velocitas;

int main(int argc, char** argv) {
    auto seatsImpl = std::make_shared<SeatsService>();

    velocitas::VehicleModelContext::getInstance().setVdbc(
        velocitas::IVehicleDataBrokerClient::createInstance("vehicledatabroker"));
    auto seatServer =
        SeatsServiceServerFactory::create(Middleware::getInstance(), seatsImpl);

    seatServer->Wait();
    return 0;
}
```

### SeatsServiceImpl.cpp

``` cpp
#include "SeatsServiceImpl.h"
#include "sdk/VehicleApp.h"
#include "sdk/VehicleModelContext.h"
#include "sdk/vdb/IVehicleDataBrokerClient.h"
#include "vehicle/Vehicle.hpp"
#include <grpc/grpc.h>
#include <services/seats/seats.grpc.pb.h>

namespace velocitas {

::grpc::Status SeatsService::Move(::grpc::ServerContext*                              context,
                                  const ::sdv::edge::comfort::seats::v1::MoveRequest* request,
                                  ::sdv::edge::comfort::seats::v1::MoveReply*         response) {
    (void)context;
    (void)response;
    vehicle::Vehicle Vehicle;

    auto seat     = request->seat();
    auto location = seat.location();
    auto row      = location.row();
    auto pos      = location.index();

    // you would need to extend this to add support for lumbar etc.
    // Vehicle.Cabin.Seat.Row(row).Pos(pos).Position.set(seat->position()->xxxxxx())->await();
    auto status = Vehicle.Cabin.Seat.Row1.DriverSide.Position.set(seat.position().base())->await();
    if (status.ok()) {
        return ::grpc::Status(::grpc::StatusCode::OK, "");
    } else {
        return ::grpc::Status(::grpc::StatusCode::CANCELLED, status.errorMessage());
    }
}

::grpc::Status
SeatsService::MoveComponent(::grpc::ServerContext*                                       context,
                            const ::sdv::edge::comfort::seats::v1::MoveComponentRequest* request,
                            ::sdv::edge::comfort::seats::v1::MoveComponentReply*         response) {
    (void)context;
    (void)request;
    (void)response;
    return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status SeatsService::CurrentPosition(
    ::grpc::ServerContext*                                         context,
    const ::sdv::edge::comfort::seats::v1::CurrentPositionRequest* request,
    ::sdv::edge::comfort::seats::v1::CurrentPositionReply*         response) {
    (void)context;
    (void)request;
    vehicle::Vehicle Vehicle;

    auto             seat          = response->mutable_seat();
    auto             seat_position = seat->mutable_position();

    auto seatPos = Vehicle.Cabin.Seat.Row1.DriverSide.Position.get()->await().value();

    // we only set base here to keep the example simple
    // extend here if yu want to set lumbar etc.
    seat_position->set_base(seatPos);
    return ::grpc::Status(::grpc::StatusCode::OK, "");
}

} // namespace velocitas
```
