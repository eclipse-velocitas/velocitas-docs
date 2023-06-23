---
title: "Python Manual Vehicle Model Creation"
date: 2022-05-09T13:43:25+05:30
weight: 60
description: >
  Learn how to create a Vehicle Model manually for Python
---

## Setup a Python Package manually

  A _Vehicle Model_ should be defined in its own Python Package. This allows to distribute the _Vehicle Model_ later as a standalone package and to use it in different _Vehicle App_ projects.

  The name of the _Vehicle Model_ package will be `my_vehicle_model` for this walkthrough.

  1. Start Visual Studio Code
  2. Select **File > Open Folder (File > Open**... on macOS) from the main menu.
  3. In the Open Folder dialog, create a `my_vehicle_model` folder and select it. Then click Select Folder (Open on macOS).
  4. Create a new file `setup.py` under `my_vehicle_model`:

     ```python
     from setuptools import setup

     setup(name='my_vehicle_model',
         version='0.1',
         description='My Vehicle Model',
         packages=['my_vehicle_model'],
         zip_safe=False)
     ```

     This is the Python package distribution script.

  5. Create an empty folder `my_vehicle_model` under `my_vehicle_model`.
  6. Create a new file `__init__.py` under `my_vehicle_model/my_vehicle_model`.

  At this point the source tree of the Python package should look like this:

  ```
  my_vehicle_model
  ├── my_vehicle_model
  │   └── __init__.py
  └── setup.py
  ```

  To verify that the package is created correctly, install it locally:

  ```bash
  pip3 install .
  ```

  The output of the above command should look like this:

  ```
  Defaulting to user installation because normal site-packages is not writeable
  Processing /home/user/projects/my-vehicle-model
  Preparing metadata (setup.py) ... done
  Building wheels for collected packages: my-vehicle-model
  Building wheel for my-vehicle-model (setup.py) ... done
  Created wheel for my-vehicle-model: filename=my_vehicle_model-0.1-py3-none-any.whl size=1238 sha256=a619bc9fbea21d587f9f0b1c1c1134ca07e1d9d1fdc1a451da93d918723ce2a2
  Stored in directory: /home/user/.cache/pip/wheels/95/c8/a8/80545fb4ff73c974ac1716a7bff6f7f753f92022c41c2e376f
  Successfully built my-vehicle-model
  Installing collected packages: my-vehicle-model
  Successfully installed my-vehicle-model-0.1
  ```

  Finally, uninstall the package again:

  ```bash
  pip3 uninstall my_vehicle_model
  ```

## Add Vehicle Models manually

  1. Install the Python _Vehicle App_ SDK:

        ```bash
        pip3 install git+https://github.com/eclipse-velocitas/vehicle-app-python-sdk.git
        ```

      The output of the above command should end with:

        ```bash
        Successfully installed sdv-x.y.z
        ```

      Now it is time to add some _Vehicle Models_ to the Python package. At the end of this section you will have a _Vehicle Model_, that contains a `Cabin` model, a `Seat`model and has the following tree structure:

          Vehicle
          └── Cabin
              └── Seat (Row, Pos)

  2. Create a new file `Seat.py` under `my_vehicle_model/my_vehicle_model`:

      ```python
      from sdv.model import Model

      class Seat(Model):

          def __init__(self, parent):
              super().__init__(parent)
              self.Position = DataPointFloat("Position", self)

      ```

      This creates the Seat model with a single data point of type `float` named `Position`.

  3. Create a new file `Cabin.py` under `my_vehicle_model/my_vehicle_model`:

      ```python
      from sdv.model import Model

        class Cabin(Model):
            def __init__(self, parent):
                super().__init__(parent)
                self.Seat = SeatCollection("Seat", self)

        class SeatCollection(Model):
            def __init__(self, name, parent):
                super().__init__(parent)
                self.name = name
                self.Row1 = self.RowType("Row1", self)
                self.Row2 = self.RowType("Row2", self)

            def Row(self, index: int):
                if index < 1 or index > 2:
                    raise IndexError(f"Index {index} is out of range")
                _options = {
                    1 : self.Row1,
                    2 : self.Row2,
                }
                return _options.get(index)

            class RowType(Model):
                def __init__(self, name, parent):
                    super().__init__(parent)
                    self.name = name
                    self.Pos1 = Seat("Pos1", self)
                    self.Pos2 = Seat("Pos2", self)
                    self.Pos3 = Seat("Pos3", self)

                def Pos(self, index: int):
                    if index < 1 or index > 3:
                        raise IndexError(f"Index {index} is out of range")
                    _options = {
                        1 : self.Pos1,
                        2 : self.Pos2,
                        3 : self.Pos3,
                    }
                    return _options.get(index)

      ```

      This creates the `Cabin` model, which contains a set of six `Seat` models, referenced by their names or by rows and positions:

      - row=1, pos=1
      - row=1, pos=2
      - row=1, pos=3
      - row=2, pos=1
      - row=2, pos=2
      - row=2, pos=3

  4. Create a new file `vehicle.py` under `my_vehicle_model/my_vehicle_model`:

      ```python
      from sdv.model import Model
      from my_vehicle_model.Cabin import Cabin


      class Vehicle(Model):
          """Vehicle model"""

          def __init__(self, name):
              super().__init__()
              self.name = name
              self.Speed = DataPointFloat("Speed", self)
              self.Cabin = Cabin("Cabin", self)

      vehicle = Vehicle("Vehicle")

      ```

  The root model of the _Vehicle Model_ tree should be called _Vehicle_ by convention and is specified, by setting parent to `None`. For all other models a parent model must be specified as the 2nd argument of the `Model` constructor, as can be seen by the `Cabin` and the `Seat` models above.

  A singleton instance of the _Vehicle Model_ called `vehicle` is created at the end of the file. This instance is supposed to be used in the _Vehicle Apps_. Creating multiple instances of the _Vehicle Model_ should be avoided for performance reasons.

### Add a Vehicle Service

_Vehicle Services_ provide service interfaces to control actuators or to trigger (complex) actions. E.g. they communicate with the vehicle internal networks like CAN or Ethernet, which are connected to actuators, electronic control units (ECUs) and other vehicle computers (VCs). They may provide a simulation mode to run without a network interface. _Vehicle Services_ may feed data to the Data Broker and may expose gRPC endpoints, which can be invoked by _Vehicle Apps_ over a _Vehicle Model_.

In this section, we add a _Vehicle Service_ to the _Vehicle Model_.

1. Create a new folder `proto` under `my_vehicle_model/my_vehicle_model`.
2. Copy your proto file under `my_vehicle_model/my_vehicle_model/proto`

   As example you could use the protocol buffers message definition [seats.proto](https://github.com/eclipse/kuksa.val.services/blob/main/seat_service/proto/sdv/edge/comfort/seats/v1/seats.proto) provided by the KUKSA.VAL services which describes a [seat control service](https://github.com/eclipse/kuksa.val.services/tree/main/seat_service).

3. Install the grpcio tools including mypy types to generate the Python classes out of the proto-file:

   ```bash
   pip3 install grpcio-tools mypy_protobuf
   ```

4. Generate Python classes from the `SeatService` message definition:

   ```bash
   python3 -m grpc_tools.protoc -I my_vehicle_model/proto --grpc_python_out=./my_vehicle_model/proto --python_out=./my_vehicle_model/proto --mypy_out=./my_vehicle_model/proto my_vehicle_model/proto/seats.proto
   ```

   This creates the following gRPC files under the `proto` folder:

   - seats_pb2.py
   - seats_pb2_grpc.py
   - seats_pb2.pyi

5. Create the `SeatService` class and wrap the gRPC service:

   ```python
   from sdv.model import Service

   from my_vehicle_model.proto.seats_pb2 import (
       CurrentPositionRequest,
       MoveComponentRequest,
       MoveRequest,
       Seat,
       SeatComponent,
       SeatLocation,
   )
   from my_vehicle_model.proto.seats_pb2_grpc import SeatsStub


   class SeatService(Service):
       "SeatService model"

       def __init__(self):
           super().__init__()
           self._stub = SeatsStub(self.channel)

       async def Move(self, seat: Seat):
           response = await self._stub.Move(MoveRequest(seat=seat), metadata=self.metadata)
           return response

       async def MoveComponent(
           self,
           seatLocation: SeatLocation,
           component: SeatComponent,
           position: int,
       ):
           response = await self._stub.MoveComponent(
               MoveComponentRequest(
                   seat=seatLocation,
                   component=component,  # type: ignore
                   position=position,
               ),
               metadata=self.metadata,
           )
           return response

       async def CurrentPosition(self, row: int, index: int):
           response = await self._stub.CurrentPosition(
               CurrentPositionRequest(row=row, index=index),
               metadata=self.metadata,
           )
           return response
   ```

   Some important remarks about the wrapping `SeatService` class
   shown above:

   - The `SeatService` class must derive from the `Service` class provided by the Python SDK.
   - The `SeatService` class must use the gRPC channel from the `Service` base class and provide it to the `_stub` in the `__init__` method. This allows the SDK to manage the physical connection to the gRPC service and use service discovery of the middleware.
   - Every method needs to pass the metadata from the `Service` base class to the gRPC call. This is done by passing the `self.metadata` argument to the metadata of the gRPC call.
