---
title: "Run runtime services in Kubernetes"
date: 2022-05-09T13:43:25+05:30
aliases:
  - /docs/tutorials/run_runtime_services_kubernetes.md
  - /docs/run_runtime_services_kubernetes.md
---

Besides [local execution](/docs/run_runtime_services_locally.md) of the vehicle runtime components, another way is to deploy them as containers in a Kubernetes control plane (like K3D). To create a K3D instance, we provide Visual Studio Code _Tasks_, a feature of Visual Studio Code. Additional information on tasks can be found [here](https://code.visualstudio.com/docs/editor/tasks).

**Quick Start:** Each step has a task that is defined in _.vscode/tasks.json_:

* Core tasks (dependent on each other in the given order):
  * ```K3D - Install prerequisites```: Install prerequisite components K3D, Helm, KubeCTL and Dapr without configuring them.
  * ```K3D - Configure control plane```: Creates a local container registry used by K3D as well as an K3D cluster with Dapr enabled.
  * ```K3D - Deploy runtime```: Deploys the runtime components (like KUKSA Data Broker, Seat Service, ...) within the K3D cluster.
  * ```K3D - Build VehicleApp```: Builds the VehicleApp and pushes it to the local K3D registry.
  * ```K3D - Deploy VehicleApp```: Builds and deploys the VehicleApp via Helm to the K3D cluster.

Each task has the required dependencies defined. If you want to run the runtime in K3D, the task ```K3D - Deploy VehicleApp``` will create and configure everything. So it's enough to run that task.

* Optional helper tasks:
  * ```K3D - Deploy VehicleApp (without rebuild)```: Deploys the VehicleApp via Helm to the K3D cluster (without rebuilding it). That requires, that the task ```K3D - Build VehicleApp``` has been executed once before.
  * ```K3D - Install tooling```: Installs tooling for local debugging (K9s)
  * ```K3D - Uninstall runtime```: Uninstalls the runtime components from the K3D cluster (without deleting the cluster).
  * ```K3D - Reset control plane```: Deletes the K3D cluster and the registry with all deployed pods/services.

K3D is configured so that _Mosquitto_ and the _KUKSA Data Broker_ can be reached from outside the container over the ports ```31883``` (Mosquitto) and ```30555```(KUKSA Data Broker). The test runner, that is running outside of the cluster, can interact with these services over those ports.

To check the status of your K3D instance (running pods, containers, logs, ...) you can either use the ```kubectl``` utility or start _K9s_ (after running the task ```K3D - Install tooling``` once) in a terminal window to have a UI for interacting with the cluster.

**Run as Bundle:** To orchestrate these tasks, a task called `K3D - Deploy VehicleApp` is available. This task runs the other tasks in the correct order. You can run this task by clicking `F1` and choose `Tasks: Run task`, then select `K3D - Deploy VehicleApp`.

**Tasks Management:** Visual Studio Code offers various other commands concerning tasks like Start/Terminate/Restart/... You can access them by pressing F1 and typing `task`. A list with available task commands will appear.

**Logging:** Running tasks appear in the Terminals View of Visual Studio Code. From there, you can see the logs of each running task.

## Uploading files to persistentVolume

Some applications (e.g. FeederCAN) might make it necessary to load custom files from mounted volume. For that reason, persistentVolume is created in k3d cluster.
All the files that are located in ```deploy/runtime/k3d/volume``` will be uploaded to the k3d cluster dynamically. In order to mount files to the directory that is accessible by the application, please refer to the deployment configuration file: [```deploy/runtime/k3d/helm/templates/bash.yaml```](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/scripts/k3d/helm/templates/persistentVolume.yaml).

Changes in ```deploy/runtime/k3d/volume``` are automatically reflected in PersistentVolume.

### Uploading custom candump file to FeederCAN

FeederCAN requires candump file. Pre-defined candump file is part of docker container release, however, if necessary, there is an option to upload the custom file by:

1. Creating/updating candump file with with name ```candump``` in ```deploy/runtime/k3d/volume```
1. Recreating the feedercan pod: ```kubectl delete pods -l app=feedercan```

More information about FeederCan can be found [here](https://github.com/eclipse/kuksa.val.feeders/tree/main/dbc2val)

## Next steps
- Tutorial: [Start runtime services locally](/docs/tutorials/run_runtime_services_locally.md)
- Tutorial: [Setup and Explore Development Enviroment](/docs/tutorials/setup_and_explore_development_environment.md)
- Concept: [Deployment Model](/docs/concepts/deployment-model.md)
- Concept: [Release your Vehicle App](/docs/concepts/vehicle_app_releases.md)
- Tutorial: [Deploy a Python Vehicle App with Helm](/docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md)