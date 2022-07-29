---
title: "Vehicle App Deployment with Helm"
date: 2022-05-09T13:43:25+05:30
weight: 6
description: >
  Learn how to prepare a Helm chart for the deployment of a Python Vehicle App.
aliases:
  - /docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md
  - /tutorial_how_to_deploy_a_vehicle_app_with_helm.md
---

This tutorial will show you how to:

- Prepare a Helm chart
- Deploy your Python Vehicle App to local K3D

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) with the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) installed. For information on how to install extensions on Visual Studio Code, see [VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery).
- Completed the tutorial [How to create a vehicle app](/docs/python-sdk/tutorial_how_to_create_a_vehicle_app.md)

## Use the sample Helm chart

If the Vehicle App has been created from the Python template repository, a sample Helm chart is already available under `deploy/VehicleApp` and can be used as it is without any modification.
This sample chart is using the values from `deploy/VehicleApp/values.yaml` file, during the deployment of the VehicleApp, the neccessary app attributes from the `AppManifest.json` (e.g. `app name` and `app port`) will overwrite the default values from the sample helm chart via the `deploy_vehicleapp.sh` script.

## Next steps

- Tutorial: [Start runtime services locally](/docs/tutorials/run_runtime_services_locally.md)
- Concept: [Release your Vehicle App](/docs/concepts/vehicle_app_releases.md)
