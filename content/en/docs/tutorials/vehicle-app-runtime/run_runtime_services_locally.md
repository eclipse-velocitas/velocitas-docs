---
weight: 1
title: "Run runtime services locally"
date: 2022-05-09T13:43:25+05:30
aliases:
  - /docs/tutorials/run_runtime_services_locally.md
  - /docs/run_runtime_services_locally.md
---

## Using tasks in Visual Studio Code

**Overview:** If you are developing in Visual Studio Code, the runtime components (like _KUKSA Data Broker_ or _Vehicle Services_) are available for local execution as _Tasks_, a feature of the Visual Studio Code. Additional information on tasks can be found [here](https://code.visualstudio.com/docs/editor/tasks).

**Quick Start:** Each component has a task that is defined in _.vscode/tasks.json_:

* Dapr (```Local - Ensure Dapr```): installs Dapr CLI and initializes Dapr if required
* Mosquitto (```Local - Mosquitto```): runs _Mosquitto_ as a container (```docker run```)
* KUKSA Data Broker (```Local - VehicleDataBroker```): runs _KUKSA Data Broker_ as a container
* (Optional) Vehicle Services (```Local - VehicleServices```): runs _Vehicle Services_, an example `Seat Service` as a container
* (Optional) Feeder Can (```Local - FeederCan```): runs _FeederCAN_ as a container

**Run as Bundle:** To orchestrate these tasks, a task called `Start Vehicle App runtime` is available. This task runs the other tasks in the correct order. You can run this task by clicking `F1` and choose `Tasks: Run task`, then select `Start Vehicle App runtime`.

**Tasks Management:** Visual Studio Code offers various other commands concerning tasks like Start/Terminate/Restart/... You can access them by pressing F1 and typing `task`. A list with available task commands will appear.

**Logging:** Running tasks appear in the Terminals View of Visual Studio Code. From there, you can see the logs of each running task.

**Scripting:** The tasks itself are executing scripts that are located in `.vscode/scripts`. These scripts download the specified version of the runtime components and execute them along with Dapr. The same mechanism can be used to register additional services or prerequisites by adding new task definitions in the `tasks.json` file.

## Add/Change service configuration

The configuration for the services is defined in the file [`./AppManifest.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/AppManifest.json). If you want to add a new service, adapt [`./AppManifest.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/AppManifest.json). If you want to update the version, change it within the file and re-run the runtime services by restarting the tasks or the script.


### Add/Change service configuration helper
```json
{
  "name": "<NAME>",
  "image": "<IMAGE>",
  "version": "<VERSION>"
}
```

## Using KUKSA Data Broker CLI

A CLI tool is provided for the interact with a running instance of the KUKSA Data Broker. It can be started by running the task `Local - VehicleDataBroker CLI`(by pressing _F1_, type _Run Task_ followed by `Local - VehicleDataBroker CLI`). The _KUKSA Data Broker_ needs to be running for you to be able to use the tool.

## Integrating a new runtime service into Visual Studio Code Task

Integration of a new runtime service can be done by duplicating one of the existing tasks.

- Create a new script based on template script `.vscode/scripts/run-vehicledatabroker.sh`
- In `.vscode/tasks.json`, duplicate section from task `run-vehicledatabroker`
- Correct names in a new code block
- **Disclaimer:** `Problem Matcher` defined in `tasks.json` is a feature of the Visual Studio Code Task, to ensure that the process runs in background
- Run task using `[F1 -> Tasks: Run Task -> <Your new task name>]`
- Task should be visible in Terminal section of Visual Studio Code

### Task CodeBlock helper

```c
{
    "label": "<__CHANGEIT: Task name__>",
    "type": "shell",
    "command": "./.vscode/scripts/<__CHANGEIT: Script Name.sh__> --task",
    "group": "none",
    "presentation": {
        "reveal": "always",
        "panel": "dedicated"
    },
    "isBackground": true,
    "problemMatcher": {
        "pattern": [
            {
                "regexp": ".",
                "file": 1,
                "location": 2,
                "message": 3
            }
        ],
        "background": {
            "activeOnStart": true,
            "beginsPattern": "^<__CHANGEIT: Regex log from your app, decision to send process in background__>",
            "endsPattern": "."
        }
    }
},
```

## Integrating a new vehicle service

Integration of a new vehicle service can be done by adding an additional case and following the template [`run-vehicleservices.sh`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.vscode/scripts/runtime/local/run-vehicleservices.sh).
### Vehicle Service CodeBlock helper
```c
# Configure Service Specific Requirements
configure_service() {
    case $1 in
        seatservice)
            ...
            ;;
        <NEW_SERVICE>)
            # Configure ports for docker to expose
            DOCKER_PORTS="-p <PORT_TO_EXPOSE>"
            # Configure ENVs need to run docker container
            DOCKER_ENVS="-e <ENV_TO_RUN_CONTAINER>"
            # Configure Dapr App Port
            DAPR_APP_PORT=
            # Configure Dapr Grpc Port
            DAPR_GRPC_PORT=
            ;;
        *)
            echo "Unknown Service to configure."
            ;;
    esac
}      
```

## Troubleshooting

**Problem description:** When integrating new services into an existing dev environment, it is highly recommended to use the Visual Studio Code Task Feature.
A new service can be easily started by calling it from bash script, however restarting the same service might lead to port conflicts (GRPC Port or APP port). That can be easily avoided by using the Visual Studio Code Task Feature.

### Codespaces

If you are using Codespaces, remember that you are working on a remote agent. That's why it could happen that the tasks are already running in the background. If that's the case a new start of the tasks will fail, since the ports are already in use. In the Dapr-tab of the sidebar you can check if there are already tasks running. Another possibility to check if the processes are already running, is to check which ports are already open. Check the Ports-tab to view all open ports (if not already open, hit `F1` and enter `View: Toggle Ports`).

## Next steps

- Tutorial: [Deploy runtime services in local Kubernetes cluster](/docs/tutorials/run_runtime_services_kubernetes.md)
- Tutorial: [Setup and Explore Development Enviroment](/docs/tutorials/setup_and_explore_development_environment.md)
- Concept: [Deployment Model](/docs/concepts/deployment-model.md)
- Concept: [Release your Vehicle App](/docs/concepts/vehicle_app_releases.md)
- Tutorial: [Deploy a Python Vehicle App with Helm](/docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md)