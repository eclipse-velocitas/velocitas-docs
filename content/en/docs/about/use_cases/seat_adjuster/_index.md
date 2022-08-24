---
title: "Seat Adjuster Use Case"
date: 2022-05-09T13:43:25+05:30
aliases:
  - /docs/velocitas/docs/seat_adjuster_use_case.md
  - /docs/velocitas/docs/reference/seat_adjuster_use_case.md
resources:
- src: "**seat_adjuster_dataflow_1*.png"
- src: "**seat_adjuster_dataflow_2*.png"
description: >
  The example of the seat adjuster provides the option of requesting the new seat position and publishing the current seat position to the customer
---

The _Seat Adjuster VehicleApp_ receives the seat position as a MQTT message and triggers a seat adjustment command of the _Seat Service_ that changes the seat position. Of course, the driver of a rented car would like the position, that he may have set himself, to be saved by the carsharing company and used for the next trip. As a result, the _Seat Adjuster VehicleApp_ subscribes to the seat position and receives the new seat position from the _Data Broker_ that streams the data from the _Seat Service_.

## Requesting new seat position

{{< imgproc seat_adjuster_dataflow_1 Resize "800x" >}}
  Architectural diagram of the seat adjuster example use case
{{< /imgproc >}}

1. The **Customer** requests the change of the seat position as MQTT message on the topic `seatadjuster/setPosition/request` with the payload:
   ```bash
   {"requestId": "xyz", "position": 300}
   ```
2. The **Seat Adjuster Vehicle App** that has subscribed to this topic, receives the request to change the seat position as a MQTT message.
3. The **Seat Adjuster Vehicle App** gets the current vehicle speed from the data broker, which is fed by the **CAN Feeder (KUKSA DBC Feeder)**.
4. With the support of the **Vehicle App SDK**, the **Seat Adjuster Vehicle App** triggers a seat adjustment command of the **Seat Service** via gRPC in the event that the speed is equal to zero. Hint: This is a helpful convenience check but not a safety check.
5. The **Seat Service** moves the seat to the new position via CAN messages.
6. The **Seat Service** returns OK or an error code as grpc status to the **Seat Adjuster Vehicle App**.
7. If everything went well, the **Seat Adjuster Vehicle App** returns a success message for the topic `seatadjuster/setPosition/response` with the payload:
   ```bash
   {"requestId": "xyz", "status": 0 }
   ```
   Otherwise, an error message will be returned:
   ```bash
   {requestId": "xyz", "status": 1, "message" = "<error message>" }
   ```
8. This success or error message will be returned to the **Customer**.

## Publishing current seat position

{{< imgproc seat_adjuster_dataflow_2 Resize "800x" >}}
  Architectural diagram of the data flow for publishing a new seat position
{{< /imgproc >}}

1. If the seat position will be changed by the driver, the new seat position will be sent to the **Seat Service** via CAN.
2.  The **Seat Service** streams the seat position via gRPC to the **KUKSA Data Broker** since it was registered beforehand.
3.  The **Seat Adjuster Vehicle App** that subscribed to the seat position receives the new seat position from the **KUKSA Data Broker** as a result.
12. The **Seat Adjuster Vehicle App** publishes this on topic `seatadjuster/currentPosition` with the payload:
    ```bash
    {"position": 350}
    ```
13. The **Customer** who has subscribed to this topic retrieves the new seat position and can store this position to use it for the next trip.
