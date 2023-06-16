---
title: "Run runtime services in Kubernetes"
date: 2022-05-09T13:43:25+05:30
aliases:
  - /docs/tutorials/run_runtime_services_kubernetes.md
  - /docs/run_runtime_services_kubernetes.md
---

Besides [local execution](/docs/run_runtime_services_locally.md) of the vehicle runtime components, another way is to deploy them as containers in a Kubernetes control plane (like K3D). To create a K3D instance, we provide Visual Studio Code _Tasks_, a feature of Visual Studio Code. Additional information on tasks can be found [here](https://code.visualstudio.com/docs/editor/tasks).

**Quick Start:** Each step has a task that is defined in `/.vscode/tasks.json`:

* Core tasks (dependent on each other in the given order):
  * ```K3D - Runtime Up```: Starts up the K3D runtime (Including configuring control plane and initializing dapr).
  * ```K3D - Build VehicleApp```: Builds the VehicleApp.
  * ```K3D - Deploy VehicleApp```: Deploys the VehicleApp via Helm to the K3D cluster.

Each task has the required dependencies defined. If you want to run the runtime in K3D, the task ```K3D - Deploy VehicleApp``` will create and configure everything. So it's enough to run that task.

* Optional helper tasks:
  * ```K3D - Deploy VehicleApp (without rebuild)```: Deploys the VehicleApp via Helm to the K3D cluster (without rebuilding it). That requires, that the task ```K3D - Build VehicleApp``` has been executed once before.
  * ```K3D - Runtime Down```: Uninstalls and removes K3D runtime configuration.

K3D is configured so that _Mosquitto_ and the _KUKSA Data Broker_ can be reached from outside the container over the ports ```31883``` (Mosquitto) and ```30555```(KUKSA Data Broker). The test runner, that is running outside of the cluster, can interact with these services over those ports.

To check the status of your K3D instance (running pods, containers, logs, ...) you can either use the ```kubectl``` utility or start _K9s_ in a terminal window to have a terminal UI for interacting with the cluster.

**Run as Bundle:** To orchestrate these tasks, you can use the task `K3D - Deploy VehicleApp`. This task runs the other tasks in the correct order. You can run this task by clicking `F1` and choose `Tasks: Run task`, then select `K3D - Deploy VehicleApp`.

**Tasks Management:** Visual Studio Code offers various other commands concerning tasks like Start/Terminate/Restart/... You can access them by pressing F1 and typing `task`. A list with available task commands will appear.

**Logging:** Running tasks appear in the Terminals View of Visual Studio Code. From there, you can see the logs of each running task. More detailed logs can be found inside your workspace's logs directory `./logs/*`

## Uploading files to persistentVolume

Some applications (e.g. FeederCAN) might make it necessary to load custom files from mounted volume. For that reason, persistentVolume is created in k3d cluster.
All the files that are located in `[./config/feedercan](https://github.com/eclipse-velocitas/devenv-runtimes/tree/main/config/feedercan)` will be uploaded to the k3d cluster dynamically. In order to mount files to the directory that is accessible by the application, please refer to the deployment configuration file: [`runtime-k3d/src/runtime/deployment/config/helm/templates/persistentVolume.yaml`](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/runtime-k3d/src/runtime/deployment/config/helm/templates/persistentVolume.yaml).

Changes in `./config/feedercan` are automatically reflected in PersistentVolume.

### Uploading custom candump file to FeederCAN

FeederCAN requires candump file. Pre-defined candump file is part of docker container release, however, if necessary, there is an option to upload the custom file by:

1. Creating/updating candump file with the name `candumpDefault.log` in `./config/feedercan`
1. Recreating the feedercan pod: `kubectl delete pods -l app=feedercan`

More information about FeederCan can be found [here](https://github.com/eclipse/kuksa.val.feeders/tree/main/dbc2val)

## Next steps

* Tutorial: [Start runtime services locally](/docs/tutorials/run_runtime_services_locally.md)
* Tutorial: [Setup and Explore Development Enviroment](/docs/tutorials/setup_and_explore_development_environment.md)
* Concept: [Deployment Model](/docs/about/deployment-model)
* Concept: [Build and release process](/docs/about/deployment_model/vehicle_app_releases)
* Tutorial: [Deploy a Python Vehicle App with Helm](/docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md)
