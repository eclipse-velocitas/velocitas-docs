---
title: "Publish Subscribe"
date: 2023-08-09T00:00:00+01:00
weight: 20
description: >
  The functional interface for supporting communication via publish and subscribe.

---

{{<table "table table-bordered">}}
| Providing CLI package       | Interface type-key    |
|-----------------------------|-----------------------|
| `devenv-runtimes`           | `pubsub`              |
{{</table>}}

## Description

This interface type introduces a dependency to a publish and subscribe middleware. While this may change in the future due to new middlewares being adopted, at the moment this will always indicate a dependency to MQTT.

If a _Vehicle App_ requires `pubsub` - this will influence the generated deployment specs to include a publish and subscribe broker (i.e. an MQTT broker).

If a _Vehicle App_ provides `pubsub` - this will influence the generated deployment specs to include a publish and subscribe broker (i.e. an MQTT broker).

## Configuration structure

{{<table "table table-bordered">}}
| Attribute | Example value | Description |
|-|-|-|
| `reads` | `[ "sampleapp/getSpeed" ]` | Array of topics which are read by the application. |
| `writes` | `[ "sampleapp/currentSpeed", "sampleapp/getSpeed/response" ]` | Array of topics which are written by the application. |
{{</table>}}

## Example

```json
{
    "type": "pubsub",
    "config": {
      "reads":  [ "sampleapp/getSpeed" ],
      "writes": [ "sampleapp/currentSpeed", "sampleapp/getSpeed/response" ]
    }
}
```
