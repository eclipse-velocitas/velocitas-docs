---
title: "Python Vehicle Model Creation"
date: 2022-05-09T13:43:25+05:30
weight: 2
description: >
  Learn how to create a simple Python Vehicle Model with Visual Studio Code and the Python Vehicle App SDK.
aliases:
  - /docs/tutorials/tutorial_how_to_create_a_vehicle_model.md
---

> We recommend that you make yourself familiar with the [Python Vehicle App SDK Overview](/docs/python-sdk//python_vehicle_app_sdk_overview.md) first, before going through this tutorial.

This tutorial will show you how to:

- Set up a Python Package
- Create a Python Vehicle Model
- Add Vehicle Services
- Distribute your Python Vehicle Model

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) with the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) installed. For information on how to install extensions on Visual Studio Code, see [VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery).

## Create a Python Vehicle Model

A Vehicle Model should be defined in its own Python Package. This makes it possible to distribute the Vehicle Model later as a standalone package and to use it in different _Vehicle App_ projects.
A Vehicle Model can be created in one of two ways.

- ### Create a Python Vehicle Model from VSS specification

  A Vehicle Model can be generated from the VSS spec. [vehicle-model-generator](https://github.com/eclipse-velocitas/vehicle-model-generator) creates a Vehicle Model from the given vspec specification and also generates a package for use in _Vehicle App_ projects.

  Follow the steps to generate a Vehicle Model.

  1. Clone the [vehicle-model-generator](https://github.com/eclipse-velocitas/vehicle-model-generator) repository in a container volume.

  2. In this container volume, clone the [vehicle-signal-specification](https://github.com/COVESA/vehicle_signal_specification) repository.
        ```
        git clone https://github.com/COVESA/vehicle_signal_specification
        ```
        After cloning if a user wants to refer to a particular branch they can checkout that branch afterwards.
        ```
        cd vehicle_signal_specification
        git checkout <branch-name>
    3. Execute the command
        ```bash
        python3 gen_vehicle_model.py -I ./vehicle_signal_specification/spec ./vehicle_signal_specification/spec/VehicleSignalSpecification.vspec -T sdv_model -N sdv_model
        ```
        This creates a `sdv_model` directory in the root of repository along with a `setup.py` file.
        To have a custom model name, refer to README of [vehicle-model-generator](https://github.com/eclipse-velocitas/vehicle-model-generator) repository. 
    4. Change the version of package in `setup.py` manually (defaults to 0.1.0).
    5. Now the newly generated `sdv_model` can be used for distribution. (See [Distributing your Python Vehicle Model](#distributing-your-python-vehicle-model))

- ### Create a Python Vehicle Model Manually

  #### Setup a Python Package manually

  A Vehicle Model should be defined in its own Python Package. This allows to distribute the Vehicle Model later as a standalone package and to use it in different _Vehicle App_ projects.

  The name of the Vehicle Model package will be `my_vehicle_model` for this walkthrough.

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

  #### Add Vehicle Models manually

  1.  Install the Python Vehicle App SDK:

          ```bash
          pip3 install git+https://github.com/eclipse-velocitas/vehicle-app-python-sdk.git@v0.4.0
          ```

          The output of the above command should end with:

          ```bash
          Successfully installed sdv-0.4.0
          ```

      Now it is time to add some Vehicle Models to the Python package. At the end of this section you will have a Vehicle Model, that contains a `Cabin` model, a `Seat`model and has the following tree structure:

          Vehicle
          └── Cabin
              └── Seat (Row, Pos)

  2.  Create a new file `Seat.py` under `my_vehicle_model/my_vehicle_model`:

      ```python
      from sdv.model import Model

      class Seat(Model):

          def __init__(self, parent):
              super().__init__(parent)
              self.Position = DataPointFloat("Position", self)

      ```

      This creates the Seat model with a single data point of type `float` named `Position`.

  3.  Create a new file `Cabin.py` under `my_vehicle_model/my_vehicle_model`:

      ```python
      from sdv.model import Model

      class Cabin(Model):

          def __init__(self, parent):
              super().__init__(parent)

              self.Seat = ModelCollection[Seat](
                  [NamedRange("Row", 1, 2), NamedRange("Pos", 1, 3)], Seat(self)
          )
      ```

      This creates the `Cabin` model, which contains a set of six `Seat` models, referenced by their rows and positions:

      - row=1, pos=1
      - row=1, pos=2
      - row=1, pos=3
      - row=2, pos=1
      - row=2, pos=2
      - row=2, pos=3

  4.  Create a new file `vehicle.py` under `my_vehicle_model/my_vehicle_model`:

      ```python
      from sdv.model import Model
      from my_vehicle_model.Cabin import Cabin


      class Vehicle(Model):
          """Vehicle model"""

          def __init__(self):
              super().__init__()
              self.Speed = DataPointFloat("Speed", self)
              self.Cabin = Cabin(self)

      vehicle = Vehicle()

      ```

  The root model of the Vehicle Model tree should be called _Vehicle_ by convention and is specified, by setting parent to `None`. For all other models a parent model must be specified as the 2nd argument of the `Model` constructor, as can be seen by the `Cabin` and the `Seat` models above.

  A singleton instance of the Vehicle Model called `vehicle` is created at the end of the file. This instance is supposed to be used in the Vehicle Apps. Creating multiple instances of the Vehicle Model should be avoided for performance reasons.

## Add a Vehicle Service

In this section, we add the `SeatService` vehicle service to the Vehicle Model.

1. Create a new folder `proto` under `my_vehicle_model/my_vehicle_model`.
2. Create a new file `seats.proto` under `my_vehicle_model/my_vehicle_model/proto`:

   ```protobuf
   syntax = "proto3";

   package sdv.edge.comfort.seats.v1;

   service Seats {
       rpc Move(MoveRequest) returns (MoveReply);
       rpc MoveComponent(MoveComponentRequest) returns (MoveComponentReply);
       rpc CurrentPosition(CurrentPositionRequest) returns (CurrentPositionReply);
   }

   message MoveRequest {
       Seat seat = 1; // The desired seat position
   }

   message MoveReply {}

   message MoveComponentRequest {
       SeatLocation seat = 1; // The seat location to change
       SeatComponent component = 2; // The component position to change
       int32 position = 3; // The desired position to move the component to
   }

   message MoveComponentReply {}

   message CurrentPositionRequest {
       uint32 row = 1; // The row of the desired seat (1 - front most)
       uint32 index = 2; // The position in the addressed row (1 - left most)
   }

   message CurrentPositionReply {
       Seat seat = 1; // The seat state that was requested
   }

   message Seat {
       SeatLocation location = 1; // The location of the seat in the vehicle
       Position position = 2; // The various positions of the seat
   }

   message SeatLocation {
       uint32 row = 1; // The row, front 1 and +1 toward rear
       uint32 index = 2; // The index within the row, 1 left most, +1 toward right
   }

   message Position {
       int32 base = 1;    // The position of the base 0 front, 1000 back
       int32 cushion = 2; // The position of the cushion 0 short, 1000 long
       int32 lumbar = 3;  // The position of the lumbar support
       int32 side_bolster = 4;   // The position of the side bolster
       int32 head_restraint = 5; // The position of the head restraint 0 down, 1000 up
   }

   enum SeatComponent {
       BASE = 0;
       CUSHION = 1;
       LUMBAR = 2;
       SIDE_BOLSTER  = 3;
       HEAD_RESTRAINT = 4;
   }
   ```

   This is the protocol buffers message definition of the `SeatService`, which is expected to be provided by the vehicle service.

3. Install the grpcio tools including mypy types to generate the python classes out of the proto-file:

   ```bash
   pip3 install grpcio-tools mypy_protobuf
   ```

4. Generate Python classes from the `SeatService` message definition:

   ```bash
   python3 -m grpc_tools.protoc -I my_vehicle_model/proto --grpc_python_out=./my_vehicle_model/proto --python_out=./my_vehicle_model/proto --mypy_out=./my_vehicle_model/proto my_vehicle_model/proto/seats.proto
   ```

   This creates the following grpc files under the `proto` folder:

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
   - The `SeatService` class must use the grpc channel from the `Service` base class and provide it to the `_stub` in the `__init__` method. This allows the SDK to manage the physical connection to the grpc service and use service discovery of the middleware.
   - Every method needs to pass the metadata from the `Service` base class to the gRPC call. This is done by passing the `self.metadata` argument to the metadata of the gRPC call.

## Distributing your Python Vehicle Model

Now you a have a Python package containing your first Python Vehicle Model and it is time to distribute it. There is nothing special about the distribution of this package, since it is just an ordinary Python package. Check out the [Python Packaging User Guide](https://packaging.python.org/en/latest/) to learn more about packaging and package distribution in Python.

### Distribute to single Vehicle App

If you want to distribute your Python Vehicle Model to a single Vehicle App, you can do so by copying the entire folder `my_vehicle_model` under the `src` folder of your Vehicle App repository and treat is a sub-package of the Vehicle App.

1. Create a new folder `my_vehicle_model` under `src` in your `Vehicle App` repository.
2. Copy the `my_vehicle_model` folder to the `src` folder of your `Vehicle App` repository.
3. Import the package `my_vehicle_model` in your `Vehicle App`:

```python
from <my_app>.my_vehicle_model import vehicle

...

my_app = MyVehicleApp(vehicle)
```

### Distribute inside an organization

If you want to distribute your Python Vehicle Model inside an organization and use it to develop multiple Vehicle Apps, you can do so by creating a dedicated Git repository and copying the files there.

1. Create new Git repository called `my_vehicle_model`
2. Copy the content under `my_vehicle_model` to the repository.
3. Release the Vehicle Model by creating a version tag (e.g., `v1.0.0`).
4. Install the Vehicle Model package to your Vehicle App:

   ```python
   pip3 install git+https://github.com/<yourorg>/my_vehicle_model.git@v1.0.0
   ```

5. Import the package `my_vehicle_model` in your Vehicle App and use it as shown in the previous section.

### Distribute publicly as open source

If you want to distribute your Python Vehicle Model publicly, you can do so by creating a Python package and distributing it on the [Python Package Index (PyPI)](https://pypi.org/). PyPi is a repository of software for the Python programming language and helps you find and install software developed and shared by the Python community. If you use the `pip` command, you are already using PyPI.

Detailed instructions on how to make a Python package available on PyPI can be found [here](https://packaging.python.org/tutorials/packaging-projects/).

## Further information

### Vehicle Apps SDK documentation
- Concept: [Python SDK Overview](/docs/concepts/python_vehicle_app_sdk_overview.md)

### Vehicle App development
- Tutorial: [Setup and Explore Development Enviroment](/docs/tutorials/setup_and_explore_development_environment.md)
- Tutorial: [Create a Python Vehicle App](/docs/tutorials/tutorial_how_to_create_a_vehicle_app.md)