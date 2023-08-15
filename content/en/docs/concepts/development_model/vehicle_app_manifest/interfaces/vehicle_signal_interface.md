---
title: "Vehicle Signal Interface"
date: 2023-08-09T00:00:00+01:00
weight: 10
description: >
  The functional interface for providing vehicle signal access via VSS specification.

---

{{<table "table table-bordered">}}
| Providing CLI package       | Interface type-key               |
|-----------------------------|----------------------------------|
| `devenv-devcontainer-setup` | `vehicle-signal-interface`       |
{{</table>}}

The _Vehicle Signal Interface_ formerly known as [_Vehicle Model_](/docs/concepts/development_model/#vehicle-models) interface type creates an interface to a signal interface described by the VSS spec. This interface will generate a source code package equivalent to the contents of your VSS JSON automatically upon devContainer creation.

If a _Vehicle App_ requires a `vehicle-signal-interface`, it will act as a consumer of datapoints already available in the system. If, on the other hand, a _Vehicle App_ provides a `vehicle-signal-interface`, it will act as a provider (formerly feeder in KUKSA terms) of the declared datapoints.

More information: [Vehicle Model Creation](/docs/tutorials/vehicle_model_creation/)

## Configuration structure

{{<table "table table-bordered">}}
| Attribute | Example value | Description |
|-|-|-|
| `src` | `"https://github.com/COVESA/vehicle_signal_specification/releases/download/v3.0/vss_rel_3.0.json"` | URI of the used COVESA Vehicle Signal Specification JSON export. URI may point to a local file or to a file provided by a server. |
| `datapoints` | | Object containing both required and provided datapoints. |
| `datapoints.required` | | Array of required datapoints. |
| `datapoints.required.[].path` | `Vehicle.Speed` | Path of the VSS datapoint. |
| `datapoints.required.[].optional` | `true`, `false` | Is the datapoint optional, i.e. can the _Vehicle App_ work without the datapoint being present in the system. Defaults to `false`. |
| `datapoints.required.[].access` | `read`, `write` | What kind of access to the datapoint is needed by the application. |
| `datapoints.provided` | | Array of provided datapoints. |
| `datapoints.provided.[].path` | `Vehicle.Cabin.Seat.Row1.Pos1.Position` | Path of the VSS datapoint. |
{{</table>}}

## Example

```json
{
    "type": "vehicle-signal-interface",
    "config": {
        "src": "https://github.com/COVESA/vehicle_signal_specification/releases/download/v3.0/vss_rel_3.0.json",
        "datapoints": {
            "required": [
                {
                    "path": "Vehicle.Speed",
                    "optional": "true",
                    "access": "read"
                }
            ],
            "provided": [
                {
                    "path": "Vehicle.Cabin.Seat.Row1.Pos1.Position"
                }
            ]
        }
    }
}
```
