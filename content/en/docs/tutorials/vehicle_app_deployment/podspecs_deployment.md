---
title: "PodSpecs Deployment"
date: 2022-05-09T13:43:25+05:30
weight: 70
description: >
  Learn how to prepare PodSpecs for the deployment of a _Vehicle App_ in a Kubernetes cluster.
aliases:
  - /docs/tutorials/vehicle_app_deployment/podspecs_deployment.md
---

This tutorial will show you how to:

- Prepare PodSpecs.
- Deploy your _Vehicle App_ to a local K3D cluster.

## Prerequisites

- Complete the tutorial [How to create a _Vehicle App_](/docs/tutorials/vehicle_app_development).

## Use the sample PodSpecs

If the _Vehicle App_ has been created from one of our template repositories, a sample PodSpec is already available inside our maintained `runtime-k3d` of the [`devenv-runtimes`](https://github.com/eclipse-velocitas/devenv-runtimes) package at [`./runtime-k3d/src/app_deployment/config/podspec/`](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/runtime-k3d/src/app_deployment/config/podspec/vehicleapp.yaml) and can be used as it is without any modification. Another example can also be found in the [documentation of Leda](https://eclipse-leda.github.io/leda/docs/app-deployment/velocitas/).

### Content

Looking at the content of the sample PodSpec, it is starting with some general information about the app and the Dapr configuration. You can define e.g. the app-port and the log-level. You could also add more labels to your app, which might help to identify the app for later usages.

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

Afterwards the configuration of the container is specified. Please be aware that `containerPort` should match the `app-port` from the Dapr configuration above. In the example the app-id of the Vehicle Data Broker is also specified, since the app wants to connect to it. Last but not least the image is defined which should be used for the deployment. In this example the local registry is used, which is created during the configuration of the controlplane (see [here](/docs/tutorials/vehicle_app_runtime/kubernetes_runtime) for details).

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
Please make sure that you have already pushed your image to the local registry before trying to deploy it. If you used the provided task (see [here](/docs/tutorials/vehicle_app_runtime/kubernetes_runtime) for details) to build your app, you can use this command:

```bash
docker push localhost:12345/sampleapp:local
```

{{% /alert %}}

### Local registry or remote registry

In the example above we used the local registry, but you can also define a remote registry in the image tag, e.g.

```yaml
image: ghcr.io/eclipse-velocitas/vehicle-app-python-template/sampleapp:0.1.0
```

If the used registry requires an authentication, you can add the needed secrets to your Kubernets configuration, see the [official documentation](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials) for details. Afterwards you have to add the secrets also to the PodSpec:

```yaml
  imagePullSecrets:
  - name: regcred
```

## Deploy your _Vehicle App_ to local K3D

### Prerequisites

- A local K3D installation must be available. For how to setup K3D, check out this [tutorial](/docs/tutorials/vehicle_app_runtime/kubernetes_runtime).

{{% alert color="warning" %}}
Make sure that there is no running _Vehicle App_ with the same name and configuration deployed on your K3D environment.
{{% /alert %}}

Deploying your app with PodSpecs can be done with one simple command:

`kubectl apply -f <podspec.yaml>`

In parallel you can check with K9S if the deployment is working correctly.

## Next steps

- Tutorial: [Start runtime services in Kubernetes](/docs/tutorials/vehicle_app_runtime/kubernetes_runtime)
- Concept: [Build and release process](/docs/concepts/deployment_model/vehicle_app_releases)
