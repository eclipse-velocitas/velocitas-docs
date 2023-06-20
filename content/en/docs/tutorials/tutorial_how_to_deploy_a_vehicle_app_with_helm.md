---
title: "Vehicle App Deployment with Helm"
date: 2022-05-09T13:43:25+05:30
weight: 80
description: >
  Learn how to prepare a Helm chart for the deployment of a _Vehicle App_ in a Kubernetes cluster.
aliases:
  - /docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md
  - /tutorial_how_to_deploy_a_vehicle_app_with_helm.md
---

This tutorial will show you how to:

- Prepare a Helm chart
- Deploy your _Vehicle App_ to a local K3D cluster

## Prerequisites

- `Devcontainer` is up and running.
- Complete the tutorial [How to create a _Vehicle App_](/docs/tutorials/vehicle-app-development)

## Use the sample Helm chart

If the _Vehicle App_ has been created from one of our template repositories, a sample Helm chart is already available inside our maintained `runtime-k3d` of the [`devenv-runtimes`](https://github.com/eclipse-velocitas/devenv-runtimes) package at [`./runtime-k3d/src/app_deployment/config/helm/`](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/runtime-k3d/src/app_deployment/config/helm/) and can be used as it is without any modification.
This sample chart is using the values from [`./runtime-k3d/src/app_deployment/config/helm/values.yaml`](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/runtime-k3d/src/app_deployment/config/helm/values.yaml) file.

{{% alert title="Note" %}}
The same app name as defined in `./app/AppManifest.json` will be used for the deployment
</br>
The app port is configurable as `vehicleAppPort` inside your `.velocitas.json` variables section. If not set there, the default value is [50008 - as defined in manifest.json](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/manifest.json#L192) of the devenv-runtimes package.
{{% /alert %}}

## Prepare a new Helm chart

If you would like to write a new helm chart, this section will guide you to adapt and deploy a new _Vehicle App_, which is called `my_vehicle_app` for this walkthrough.

1. Start Visual Studio Code and open the previously created _Vehicle App_ repository.
1. Create a new folder `my_vehicle_app` under `deploy`
1. Copy all files from the [devenv-runtimes/runtime-k3d/src/app_deployment/config/helm](https://github.com/eclipse-velocitas/devenv-runtimes/tree/main/runtime-k3d/src/app_deployment/config/helm) folder to the new folder `deploy/my_vehicle_app`.
1. Rename the file `deploy/my_vehicle_app/helm/templates/vehicleapp.yaml` to `deploy/my_vehicle_app/helm/templates/my_vehicle_app.yaml`
1. Open `deploy/my_vehicle_app/helm/Chart.yaml` and change the name of the chart to `my_vehicle_app` and provide a meaningful description.

   ```yaml
   apiVersion: v2
   name: my-vehicle-app
   description: Short description for my-vehicle-app

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

1. Open `deploy/my_vehicle_app/helm/values.yaml` and change `name`, `repository` and `daprAppid` to `my-vehicle-app`. Rename the root node from `imageVehicleApp` to `imageMyVehicleApp`.

   ```yaml
   imageMyVehicleApp:
     name: my-vehicle-app
     repository: k3d-registry.localhost:12345/my-vehicle-app
     pullPolicy: Always
     # Overrides the image tag whose default is the chart appVersion.
     tag: "#SuccessfulExecutionOfReleaseWorkflowUpdatesThisValueToReleaseVersionWithoutV#"
     daprAppid: my-vehicle-app
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

At this point, the Helm chart is prepared for the next step and the folder structure under `deploy/my_vehicle_app` should look like this:

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

## Deploy your _Vehicle App_ to the local K3D cluster

### Prerequisites

- A local K3D installation must be available. For how to setup K3D, check out this [tutorial](/docs/run_runtime_services_kubernetes.md).

After the Helm chart has been prepared, you can deploy it to the local K3D cluster by following the steps:

1. Building and pushing the Docker image for your _Vehicle App_

```bash
DOCKER_BUILDKIT=1 docker build -f ./app/Dockerfile --progress=plain -t localhost:12345/my-vehicle-app:local . --no-cache

docker push localhost:12345/my-vehicle-app:local
```

2. Installing the Helm Chart

``` bash
helm install my-vapp-chart ./deploy/my_vehicle_app --values ./deploy/my_vehicle_app/values.yaml --wait --timeout 60s
```

These steps are building the local source code of the application into a container, pushing it to the local cluster registry and deploying the app via a helm chart to the K3D cluster. Rerun the steps after you have changed the source code of your application to re-deploy with the latest changes.

If you have issues installing the helm chart again try uninstalling the chart upfront:

```bash
helm uninstall my-vapp-chart
```

## Next steps

- Tutorial: [Start runtime services locally](/docs/tutorials/vehicle-app-runtime/run_runtime_services_locally)
- Concept: [Build and release process](/docs/concepts/deployment_model/vehicle_app_releases)
