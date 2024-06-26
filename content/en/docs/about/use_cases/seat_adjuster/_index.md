---
title: "Seat Adjuster"
date: 2022-05-09T13:43:25+05:30
weight: 1
aliases:
  - /docs/about/use_cases/seat_adjuster.md
resources:
- src: "**seat_adjuster_dataflow_1*.png"
- src: "**seat_adjuster_dataflow_2*.png"
description: >
  Provides option to request a new seat position and to publish the current seat position
---

In the scenario of a car sharing company, the goal is to provide the functionality of automatically adjusting the driver's seat position based on their preferred settings stored in their profile. When the driver unlocks the car, a request is sent to the vehicle to retrieve the preferred seat position. This is where your implementation begins.

The _Seat Adjuster Vehicle App_ receives a MQTT message containing the seat position, which then triggers a seat adjustment command through the _Seat Service_ to change the seat position. Additionally, to ensure convenience for future trips, the car sharing company saves the driver's preferred seat position and utilizes it accordingly. _The Seat Adjuster Vehicle App_ subscribes to the seat position, receiving updates from the _Databroker_, which streams data from the _Seat Service_.

## Requesting new seat position

![seat_adjuster_dataflow_1](./seat_adjuster_dataflow_1.png)

1. The **Customer** requests the change of the seat position as MQTT message on the topic `seatadjuster/setPosition/request` with the payload:

   ```json
   {"requestId": 42, "position": 300}
   ```

2. The **Seat Adjuster _Vehicle App_** that has subscribed to this topic, receives the request to change the seat position as a MQTT message.
3. The **Seat Adjuster _Vehicle App_** gets the current vehicle speed from the Databroker, which is fed by the **CAN Provider (KUKSA CAN Provider)**.
4. With the support of the **_Vehicle App_ SDK**, the **Seat Adjuster _Vehicle App_** triggers a seat adjustment command of the **Seat Service** via gRPC in the event that the speed is equal to zero. Hint: This is a helpful convenience check but not a safety check.
5. The **Seat Service** moves the seat to the new position via CAN messages.
6. The **Seat Service** returns OK or an error code as gRPC status to the **Seat Adjuster _Vehicle App_**.
7. If everything went well, the **Seat Adjuster _Vehicle App_** returns a success message for the topic `seatadjuster/setPosition/response` with the payload:

   ```json
   {"requestId": 42, "status": 0 }
   ```

   Otherwise, an error message will be returned:

   ```json
   {"requestId": 42, "status": 1, "message": "<error message>" }
   ```

8. This success or error message will be returned to the **Customer**.

## Publishing current seat position

![seat_adjuster_dataflow_2](./seat_adjuster_dataflow_2.png)

1. If the seat position will be changed by the driver, the new seat position will be sent to the **Seat Service** via CAN.
2. The **Seat Service** streams the seat position via gRPC to the **KUKSA Databroker** since it was registered beforehand.
3. The **Seat Adjuster _Vehicle App_** that subscribed to the seat position receives the new seat position from the **KUKSA Databroker** as a result.
4. The **Seat Adjuster _Vehicle App_** publishes this on topic `seatadjuster/currentPosition` with the payload:

    ```json
    {"position": 350}
    ```

5. The **Customer** who has subscribed to this topic retrieves the new seat position and can store this position to use it for the next trip.

## Example Code

You can find an example implementation of a Seat Adjuster _Vehicle App_ here:
[Seat Adjuster](https://github.com/eclipse-velocitas/vehicle-app-python-sdk/tree/main/examples/seat-adjuster)
