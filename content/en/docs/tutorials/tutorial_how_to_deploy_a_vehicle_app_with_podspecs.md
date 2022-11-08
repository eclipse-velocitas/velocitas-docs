---
title: "Vehicle App Deployment via PodSpecs"
date: 2022-05-09T13:43:25+05:30
weight: 6
description: >
  Learn how to prepare PodSpecs for the deployment of a Vehicle App.
aliases:
  - /docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_podspecs.md
  - /tutorial_how_to_deploy_a_vehicle_app_with_podspecs.md
---

This tutorial will show you how to:

- Prepare PodSpecs
- Deploy your Vehicle App to local K3D

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) with the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) installed. For information on how to install extensions on Visual Studio Code, see [VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery).
- Completed the tutorial [How to create a vehicle app](/docs/tutorials/vehicle-app-development)

## Use the sample PodSpecs

If the Vehicle App has been created from one of our template repositories, a sample PodSpec is already available under `deploy/VehicleApp/podspec` and can be used as it is without any modification. Another example can also be found in the [documentation of Leda](https://eclipse-leda.github.io/leda/docs/app-deployment/velocitas/).

### Content

Looking at the content of the sample-podspec, it is starting with some general information about the app and the dapr configuration. You can define e.g. the app-port and the log-level. You could also add more labels to your app, which might help to identify the app for later usages.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sampleapp
  annotations:
    dapr.io/enabled: "true"
    dapr.io/app-id: sampleapp
    dapr.io/app-port: "50008"
    dapr.io/app-protocol: grpc
    dapr.io/log-level: info
  labels:
    app: sampleapp
```
Afterwards the configuration of the container is specified. Please be aware that the container-port should match the app-port from the dapr-config above. In the example the app-id of the VehicleDataBroker is also specified, since the app wants to connect to it. Last but not least the image is defined which should be used for the deployment. In this example the local registry is used, which is created during the configuration of the controlplane (see [here](/docs/run_runtime_services_kubernetes.md) for details).

```yaml
spec:
  containers:
    - name: sampleapp
      imagePullPolicy: IfNotPresent
      ports:
        - containerPort: 50008
      env:
        - name: VEHICLEDATABROKER_DAPR_APP_ID
          value: "vehicledatabroker"
      image: k3d-registry.localhost:12345/sampleapp:local
```
{{% alert title="Note" %}}
Please make sure that you already pushed your image to the local registry before trying to deploy it. If you used the provided tasks (see [here](/docs/run_runtime_services_kubernetes.md) for details), you can use the following commands: 
`docker tag localhost:12345/sampleapp:local k3d-registry.localhost:12345/sampleapp:local`
`docker push k3d-registry.localhost:12345/sampleapp:local`
{{% /alert %}}

### Local registry or remote registry

In the example above we used the local registry, but you can also define a remote registry in the image tag, e.g.

```yaml
image: ghcr.io/eclipse-velocitas/vehicle-app-python-template/sampleapp:0.0.1-bcx
```

If your registry is not public, you might to add secrets to your Kubernets config, see the [official documentation](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials) for details. Afterwards you have to add the secrets also to the PodSpec:

```yaml
  imagePullSecrets:
  - name: regcred
```

## Deploy your Vehicle App to local K3D

### Prerequisites

- A local K3D installation must be available. For how to setup K3D, check out this [tutorial](/run_runtime_services_kubernetes).

Deploying your app with PodSpecs can be done with one simple command:

`kubectl apply -f <podspec.yaml>`

In parallel you can check with K9S if the deployment is working correctly.

## Next steps

- Tutorial: [Start runtime services locally](/docs/tutorials/vehicle-app-runtime/run_runtime_services_locally)
- Concept: [Build and release process](/docs/about/deployment_model/vehicle_app_releases)
