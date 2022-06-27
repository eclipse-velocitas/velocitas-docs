---
title: "Seat Adjuster"
date: 2022-05-09T13:43:25+05:30
aliases:
  - /docs/velocitas/docs/seat_adjuster_use_case.md
---

The example of the seat adjuster provides the option to request the new seat position and to publish the current seat position to the customer and demonstrate so the content of the Eclipse project **Velocitas**. The following chapter describing the data flow for the use cases.

## Requesting new seat position

![Use Case](/assets/SeatAdjuster-dataflow-1.svg)

1. The **Customer** requests the change of the seat position as MQTT message on the topic `seatadjuster/setPosition/request` with the payload:
   ```bash
   {"requestId": "xyz", "position": 300}
   ```
2. The **Seat Adjuster Vehicle App** that has subscribed to this topic, receives the request to change the seat position as MQTT message
3. The **Seat Adjuster Vehicle App** gets the current vehicle speed from the data broker which is fed by the **Generic CAN Feeder**.
4. With support of the **Vehicle App SDK** the **Seat Adjuster Vehicle App** triggers a seat adjustment command of the **Seat Service** via gRPC in case the speed is equal to zero. Hint: This is a helpful convenience check but not a safety check.
5. The **Seat Service** moves the seat to the new position via CAN messages.
6. The **Seat Service** returns OK or an error code as grpc status to the **Seat Adjuster Vehicle App**.
7. If everything went well the **Seat Adjuster Vehicle App** returns for the topic `seatadjuster/setPosition/response` a success message with the payload:
   ```bash
   {"requestId": "xyz", "status": 0 }
   ```
   Otherwise an error message will be returned:
   ```bash
   {requestId": "xyz", "status": 1, "message" = "<error message>" }
   ```
8. This success or error message will be returned to the **Customer**.

## Publishing current seat position

{{<raw>}}
<img src="/assets/SeatAdjuster-dataflow-2.svg" alt="Use Case"/>
{{</raw>}}

9. If the seat position will be changed by the driver, the new seat position will be send to the **Seat Service** via CAN.
10. The **Seat Service** streames the seat position via gRPC to the **Vehicle Data Broker** since it has been registered beforehand.
11. The **Seat Adjuster Vehicle App** that has subscribed to the seat position and therefore receives the new seat position from the **Vehicle Data Broker**.
12. The **Seat Adjuster Vehicle App** publish this on topic `seatadjuster/currentPosition` with payload:
    ```bash
    {"position": 350}
    ```
13. The **Customer** who has subscribed to this topic, retrieves the new seat position and can store this position to use it for the next trip.
