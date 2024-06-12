---
title: "Kanto Runtime"
date: 2022-05-09T13:43:25+05:30
description: >
  Learn how to run the _Vehicle App_ Runtime Services in Kanto.
aliases:
  - /docs/tutorials/vehicle_app_runtime/kanto_runtime
---

Besides starting the vehicle runtime components [locally](/docs/tutorials/vehicle_app_runtime/local_runtime), another way is to deploy them as containers using [Kanto](https://eclipse.dev/kanto/). To start the runtime, we provide VS Code _Tasks_, a feature of Visual Studio Code. Additional information on tasks can be found [here](https://code.visualstudio.com/docs/editor/tasks).

**Quick Start:** Each step has a task that is defined in `/.vscode/tasks.json`:

* Core tasks (dependent on each other in the given order):
  * ```Kanto - Runtime Up```: Starts up the Kanto runtime and deploys the runtime components.
  * ```Kanto - Build VehicleApp```: Builds the _VehicleApp_.
  * ```Kanto - Deploy VehicleApp```: Deploys the _VehicleApp_ as container in the Kanto runtime.

* Optional helper tasks:
  * ```Kanto - Deploy VehicleApp (without rebuild)```: Deploys the _VehicleApp_ as container in the Kanto runtime but does not build it upfront. That requires, that the task ```Kanto - Build VehicleApp``` has been executed once before.
  * ```Kanto - Runtime Down```: Stops the Kanto runtime and all deployed containers.

**Run as Bundle:** To orchestrate these tasks, you can use the task `Kanto - Deploy VehicleApp`. This task runs the other tasks in the correct order. You can run this task by clicking `F1` and choose `Tasks: Run task`, then select `Kanto - Deploy VehicleApp`.

**Tasks Management:** Visual Studio Code offers various other commands concerning tasks like Start/Terminate/Restart/... You can access them by pressing F1 and typing `task`. A list with available task commands will appear.

**Logging:** Running tasks appear in the Terminals View of Visual Studio Code. From there, you can see the logs of each running task. More detailed logs can be found inside your workspace's logs directory `./logs/*`

## KantUI

The Leda team developed a tool to easily work with Kanto. It is similar to [K9S](https://k9scli.io/) for Kubernetes. You can find more details about KantUI in the [documentation of Leda](https://eclipse-leda.github.io/leda/docs/general-usage/utilities/kantui/).

In the devcontainer KantUI is already installed and it can be started via:

```bash
sudo kantui
```

After starting the Kanto runtime with the mentioned tasks above, you will directly see all the running containers in KantUI. Now you could also take a look at the logs, delete or stop single containers. After you deployed your application to Kanto, this container will also show up and can be handled with KantUI.

## Mounting folders for FeederCAN

Some applications (e.g. FeederCAN) might make it necessary to load custom files from a mounted volume.
All the files that are located in `[./config/feedercan](https://github.com/eclipse-velocitas/devenv-runtimes/tree/main/config/feedercan)` will be automatically mounted into the container. In order to mount files to the directory that is accessible by the application, please refer to the deployment configuration file: [`runtime-kanto/src/runtime/deployment/feedercan.json`](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/runtime-kanto/src/runtime/deployment/feedercan.json).

### Uploading custom candump file to FeederCAN

FeederCAN requires a candump file. A pre-defined candump file is already part of our delivery, however, if necessary, there is an option to upload a custom file by:

1. Creating/updating candump file with the name `candumpDefault.log` in `./config/feedercan`
1. Restarting Kanto (execute the tasks ```Kanto - Runtime Down``` and ```Kanto - Runtime Up```)

More information about the CAN Provider can be found [here](https://github.com/eclipse-kuksa/kuksa-can-provider)

## Next steps

* Concept: [Deployment Model](/docs/concepts/deployment_model)
* Concept: [Build and release process](/docs/concepts/deployment_model/vehicle_app_releases)
* Tutorial: [Start runtime services locally](/docs/tutorials/vehicle_app_runtime/local_runtime)
* Tutorial: [Quickstart](/docs/tutorials/quickstart.md)
