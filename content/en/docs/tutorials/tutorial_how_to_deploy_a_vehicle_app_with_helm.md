---
title: "Vehicle App Deployment with Helm"
date: 2022-05-09T13:43:25+05:30
weight: 6
description: >
  Learn how to prepare a Helm chart for the deployment of a Vehicle App.
aliases:
  - /docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md
  - /tutorial_how_to_deploy_a_vehicle_app_with_helm.md
---

This tutorial will show you how to:

- Prepare a Helm chart
- Deploy your Vehicle App to local K3D

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) with the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) installed. For information on how to install extensions on Visual Studio Code, see [VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery).
- Completed the tutorial [How to create a vehicle app](/docs/tutorials/vehicle-app-development)

## Use the sample Helm chart

If the Vehicle App has been created from one of our template repositories, a sample Helm chart is already available under `deploy/VehicleApp` and can be used as it is without any modification.
This sample chart is using the values from `deploy/VehicleApp/values.yaml` file, during the deployment of the VehicleApp, the neccessary app attributes from the `AppManifest.json` (e.g. `app name` and `app port`) will overwite the default values from the sample helm chart via the `deploy_vehicleapp.sh` script.

## Prepare a new Helm chart

If you would like to write a new helm chart, this section will guide you to adapt and deploy a new vehicle app, which is called `my_vehicle_app` for this walkthrough.

1. Start Visual Studio Code and open the previously created Vehicle App repository.
1. Create a new folder `my_vehicle_app` under `deploy`
1. Copy all files from the `deploy/VehicleApp` folder to the new folder `deploy/my_vehicle_app`.
1. Rename the file `deploy/my_vehicle_app/helm/templates/vehicleapp.yaml` to `deploy/my_vehicle_app/helm/templates/my_vehicle_app.yaml`
1. Open `deploy/my_vehicle_app/helm/Chart.yaml` and change the name of the chart to `my_vehicle_app` and provide a meaningful description.

   ```yaml
   apiVersion: v2
   name: my_vehicle_app
   description: Short description for my_vehicle_app

   # A chart can be either an 'application' or a 'library' chart.
   #
   # Application charts are a collection of templates that can be packaged into versioned archives
   # to be deployed.
   #
   # Library charts provide useful utilities or functions for the chart developer. They're included as
   # a dependency of application charts to inject those utilities and functions into the rendering
   # pipeline. Library charts do not define any templates and cannot be deployed as a result.
   type: application

   # This is the chart version. This version number should be incremented each time you make changes
   # to the chart and its templates, including the app version.
   # Versions are expected to follow Semantic Versioning (https://semver.org/)
   version: 0.1.0

   # This is the version number of the application being deployed. This version number should be
   # incremented each time you make changes to the application. Versions are not expected to
   # follow Semantic Versioning. They should reflect the version the application is using.
   appVersion: 1.16.0
   ```

1. Open `deploy/my_vehicle_app/helm/values.yaml` and change `name`, `repository` and `daprAppid` to `my_vehicle_app`. Rename the root node from `imageVehicleApp` to `imageMyVehicleApp`.

   ```yaml
   imageMyVehicleApp:
     name: my_vehicle_app
     repository: local/my_vehicle_app
     pullPolicy: Always
     # Overrides the image tag whose default is the chart appVersion.
     tag: "#SuccessfulExecutionOfReleaseWorkflowUpdatesThisValueToReleaseVersionWithoutV#"
     daprAppid: my_vehicle_app
     daprPort: 50008

     nameOverride: ""
     fullnameOverride: ""
   ```

1. Open `deploy/my_vehicle_app/helm/templates/my_vehicle_app.yaml` and replace `imageVehicleApp` with `imageMyVehicleApp`:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
   name: {{.Values.imageMyVehicleApp.name}}
   labels:
       app: {{.Values.imageMyVehicleApp.name}}
   spec:
   selector:
       matchLabels:
       app: {{.Values.imageMyVehicleApp.name}}
   template:
       metadata:
       annotations:
           dapr.io/enabled: "true"
           dapr.io/app-id: "{{.Values.imageMyVehicleApp.daprAppid}}"
           dapr.io/app-port: "{{.Values.imageMyVehicleApp.daprPort}}"
           dapr.io/log-level: "debug"
           dapr.io/config: "config"
           dapr.io/app-protocol: "grpc"
       labels:
           app: {{.Values.imageMyVehicleApp.name}}
           {{- include "helm.selectorLabels" . | nindent 8 }}
       spec:
       containers:
           - name: {{.Values.imageMyVehicleApp.name}}
           image: "{{ .Values.imageMyVehicleApp.repository }}:{{ .Values.imageMyVehicleApp.tag | default .Chart.AppVersion }}"
           imagePullPolicy: {{ .Values.imageMyVehicleApp.pullPolicy }}

   ```

1. update or copy the scripts `build_vehicleapp.sh` and `deploy_vehicleapp.sh` in path (```.vscode/scripts/runtime/k3d/```) for the local Kubernates deployment and adjust the values according to the values `AppManifest.json`:
    - APP_NAME
    - APP_PORT
    - DOCKERFILE_FILE

1. update the script ```.github/scripts/deploy_imagefromghcr.sh``` for the CI workflow with the correct values from the `AppManifest.json` as above.

At this point, the Helm chart and updated scripts are ready to use and folder structure under `deploy/my_vehicle_app` should look like this:

``` bash
deploy
├── my_vehicle_app
│   └── helm
│       └── templates
│           └── _helpers.tpl
│           └── my_vehicle_app.yaml
│────────── .helmignore
│────────── Chart.yaml
└────────── values.yaml
```

## Deploy your Vehicle App to local K3D

### Prerequisites

- A local K3D installation must be available. For how to setup K3D, check out this [tutorial](/run_runtime_services_kubernetes.md).

After the Helm chart has been prepared, you can deploy it to local K3D.
Execute the script:

``` bash
deploy/my_vehicle_app/deploy-my-vehicle-app.sh
```

This script builds the local source code of the application into a container, pushes that container to the local cluster registry and deploys the app via a helm chart to the K3D cluster. Rerun this script after you have changed the source code of your application to re-deploy with the latest changes.

## Next steps

- Tutorial: [Start runtime services locally](/docs/tutorials/run_runtime_services_locally.md)
- Concept: [Release your Vehicle App](/docs/concepts/vehicle_app_releases.md)
