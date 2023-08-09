---
title: "Vehicle Model"
date: 2023-08-09T00:00:00+01:00
weight: 30
description: >
  The logical interface for providing vehicle data access via a VSS-based vehicle model.

---

## Interface type key: `vehicle-model`

## Description

The [_Vehicle Model_](/docs/concepts/development_model/#vehicle-models) interface type creates an interface to a vehicle model described by VSS. Once specified, this interface will generate a source code package equivalent to the contents of your VSS JSON automatically upon devContainer creation.

More information: [Vehicle Model Creation](/docs/tutorials/vehicle_model_creation/)

## Configuration structure

{{<table "table table-bordered">}}
| Attribute | Example value | Description |
|-|-|-|
| `src` | `"https://github.com/COVESA/vehicle_signal_specification/releases/download/v3.0/vss_rel_3.0.json"` | URI of the used COVESA Vehicle Signal Specification JSON export. URI may point to a local file or to a file provided by a server. |
| `datapoints` | | Array of required (or optional) datapoints. |
| `datapoints.[].path` | `Vehicle.Speed` | Path of the VSS datapoint. |
| `datapoints.[].required` | `true`, `false` | Is the datapoint required or can the _Vehicle App_ work without the datapoint being present in the system. |
| `datapoints.[].access` |  `read`, `write` | What kind of access to the datapoint is needed by the application.
{{</table>}}
