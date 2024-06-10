# gRPC service generation
This tutorial shows how to generate a basic gRPC service like a seat service. For this example the proto file under https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto is taken.

## App configuration

```json
{
  "type": "grpc-interface",
  "config": {
      "src": "https://raw.githubusercontent.com/eclipse-kuksa/kuksa-incubation/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto",
      // add here configurations if you are trying to write a client for the service definition
      "required": {
        "methods": [
          "Move", "CurrentPosition"
        ]
      },
      // add this line if you want to provide the server implementation to the service definition
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

## Example

All files included from `services/seats` are auto-generated and added to the app project as Conan dependency. For writing a complete gRPC service you need two apps(files). One is implementing a client(`client.cpp`) and the other one is for providing the server(`server.cpp`). For the serverimplementation there is the `*ServiceImpl.cpp`. These will be basically two `velocitas applications`. To build the both binaries properly you need to adapt your `CMakeLists.txt` as following:

```
// CMakeLists.txt
set(TARGET_NAME "app")

add_executable(server
    main.cpp
)

add_executable(${TARGET_NAME}
    client.cpp
)

target_link_libraries(server
    ${CONAN_LIBS}
)

target_link_libraries(${TARGET_NAME}
    ${CONAN_LIBS}
)
```

``` cpp
// client.cpp
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
    // we only set base here for the purpose to keep the example simple
    // extend here if yu want to set lumbar etc.
    seat_position.set_base(1000);

    seat.set_allocated_location(&seat_location);
    seat.set_allocated_position(&seat_position);

    request.set_allocated_seat(&seat);

    auto status = serviceClient->Move(&context, request, &response);

    std::cout << "gRPC Server returned code: " << status.error_code() << std::endl;
    std::cout << "gRPC error message: " << status.error_message().c_str() << std::endl;

    if (status.error_code() == ::grpc::StatusCode::UNIMPLEMENTED) {
        return 0;
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

    return 1;
}
```

``` cpp
// server.cpp
#include "sdk/middleware/Middleware.h"
#include "services/seats/SeatsServiceServerFactory.h"
#include "SeatsServiceImpl.h"

#include <memory>

using namespace velocitas;

int main(int argc, char** argv) {
    auto seatsImpl = std::make_shared<SeatsService>();

    auto seatServer =
        SeatsServiceServerFactory::create(Middleware::getInstance(), seatsImpl);
    velocitas::VehicleModelContext::getInstance().setVdbc(
        velocitas::IVehicleDataBrokerClient::createInstance("vehicledatabroker"));

    seatServer->Wait();
    return 0;
}
```

``` cpp
// SeatsServiceImpl.cpp
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

### Run example
```shell
  velocitas exec build-system install   
  velocitas exec build-system build 
```

``` shell
  export SDV_SEATS_ADDRESS=127.0.0.1:1234
  export SDV_VEHICLEDATABROKER_ADDRESS=127.0.0.1:55555
  ./build/bin/server
```

``` shell 2
  export SDV_SEATS_ADDRESS=127.0.0.1:1234
  export SDV_VEHICLEDATABROKER_ADDRESS=127.0.0.1:55555
  ./build/bin/app
```
