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

## Prepare a Helm chart

If the Vehicle App has been created from the Python template repository, a sample Helm chart is already available under `deploy/SeatAdjusterApp`.

This will be adapted to deploy a new vehicle app, which is called `my_vehicle_app` for this walkthrough.

1. Start Visual Studio Code and open the previously created Vehicle App repository.
1. Create a new folder `my_vehicle_app` under `deploy`
1. Copy all files from the `deploy/SeatAdjusterApp` folder to the new folder `deploy/my_vehicle_app`.
1. Rename the file `deploy/my_vehicle_app/helm/templates/seatadjuster.yaml` to `deploy/my_vehicle_app/helm/templates/my_vehicle_app.yaml`
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

1. Open `deploy/my_vehicle_app/helm/values.yaml` and change `name`, `repository` and `daprAppid` to `my_vehicle_app`. Rename the root node from `imageSeatAdjusterApp` to `imageMyVehicleApp`.

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

1. Open `deploy/my_vehicle_app/helm/templates/my_vehicle_app.yaml` and replace `imageSeatAdjusterApp` with `imageMyVehicleApp`:

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

1. Rename `deploy/my_vehicle_app/deploy_seat-adjuster-app.sh` to `deploy/my_vehicle_app/deploy-my-vehicle-app.sh` and replace all occurences of `SeatAdjusterApp` with `MyVehicleApp` and `seatservice` with `my-vehicle-app`.

   ```sh
   #!/bin/bash

   WORKING_DIR=$(pwd)

   if [ -f "./../../github_token.txt" ];
   then
       GITHUB_TOKEN="github_token,src=github_token.txt"
   else
       GITHUB_TOKEN="github_token"
   fi

   if [ -n "$HTTP_PROXY" ]; then
       echo "Building image with proxy configuration"

       cd $WORKING_DIR/../../
       DOCKER_BUILDKIT=1 docker build \
       -f src/MyVehicleApp/Dockerfile \
       --progress=plain --secret id=$GITHUB_TOKEN \
       -t localhost:12345/my-vehicle-app:local \
       --build-arg HTTP_PROXY="$HTTP_PROXY" \
       --build-arg HTTPS_PROXY="$HTTPS_PROXY" \
       --build-arg FTP_PROXY="$FTP_PROXY" \
       --build-arg ALL_PROXY="$ALL_PROXY" \
       --build-arg NO_PROXY="$NO_PROXY" . --no-cache
       docker push localhost:12345/my-vehicle-app:local

       cd $WORKING_DIR
   else
       echo "Building image without proxy configuration"
       # Build, push vehicleapi image - NO PROXY

       cd $WORKING_DIR/../../
       DOCKER_BUILDKIT=1 docker build -f src/MyVehicleApp/Dockerfile --progress=plain --secret id=$GITHUB_TOKEN -t localhost:12345/my-vehicle-app:local . --no-cache
       docker push localhost:12345/my-vehicle-app:local

       cd $WORKING_DIR
   fi

   helm uninstall vapp-chart --wait

   # Deploy in Kubernetes
   helm install vapp-chart ./helm --values ../runtime/k3d/values.yml --wait --timeout 60s --debug

   ```

At this point, the Helm chart and the sh-script are ready to use and folder structure under `deploy/my_vehicle_app` should look like this:

``` bash
deploy
├── my_vehicle_app
│   └── helm
│       └── templates
│           └── _helpers.tpl
│           └── my_vehicle_app.yaml
│────────── .helmignore
│────────── Chart.yaml
│────────── values.yaml
└────── deploy-my-vehicle-app.sh
```

## Deploy your Python Vehicle App to local K3D

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