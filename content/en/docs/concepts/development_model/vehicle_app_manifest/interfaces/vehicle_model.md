---
title: "Vehicle Signal Specification based Vehicle Model"
date: 2023-08-09T00:00:00+01:00
weight: 10
description: >
  The logical interface for providing vehicle data access via a VSS-based vehicle model.

---

{{<table "table table-bordered">}}
| Providing CLI package       | Interface type-key    | Supported directions   |
|-----------------------------|-----------------------|------------------------|
| `devenv-devcontainer-setup` | `vehicle-model`       | `required`, `provided` |
{{</table>}}

The [_Vehicle Model_](/docs/concepts/development_model/#vehicle-models) interface type creates an interface to a vehicle model described by VSS. Once specified, this interface will generate a source code package equivalent to the contents of your VSS JSON automatically upon devContainer creation.

If a _Vehicle App_ requires a `vehicle-model`, it will act as a consumer of datapoints already available in the system. If, on the other hand, a _Vehicle App_ provides a `vehicle-model`, it will act as a provider (formerly feeder in KUKSA terms) of the declared datapoints.

More information: [Vehicle Model Creation](/docs/tutorials/vehicle_model_creation/)

## Configuration structure

{{<table "table table-bordered">}}
| Attribute | Example value | Description |
|-|-|-|
| `src` | `"https://github.com/COVESA/vehicle_signal_specification/releases/download/v3.0/vss_rel_3.0.json"` | URI of the used COVESA Vehicle Signal Specification JSON export. URI may point to a local file or to a file provided by a server. |
| `datapoints` | | Array of required or provided datapoints. |
| `datapoints.[].path` | `Vehicle.Speed` | Path of the VSS datapoint. |
| `datapoints.[].required` | `true`, `false` | <span style="color:red;">**Attribute only supported in requires direction!**</span><br/>Is the datapoint required or can the _Vehicle App_ work without the datapoint being present in the system. |
| `datapoints.[].access` |  `read`, `write` | <span style="color:red;">**Attribute only supported in requires direction!**</span><br/>What kind of access to the datapoint is needed by the application.
{{</table>}}

## Example

```json
{
    "type": "vehicle-model",
    "config": {
        "src": "https://github.com/COVESA/vehicle_signal_specification/releases/download/v3.0/vss_rel_3.0.json",
        "datapoints": [
            {
                "path": "Vehicle.Speed",
                "required": "true",
                "access": "read"
            }
        ]
    }
}
```
