---
weight: 1
title: "Run runtime services locally"
date: 2022-05-09T13:43:25+05:30
aliases:
  - /docs/tutorials/run_runtime_services_locally.md
  - /docs/run_runtime_services_locally.md
---

## Using tasks in Visual Studio Code

**Overview:** If you are developing in Visual Studio Code, the runtime components (like _KUKSA Data Broker_ or _Vehicle Services_) are available for local execution coming from our _devenv-runtimes_ package and are accessible as _Tasks_, a feature of the Visual Studio Code. Additional information on tasks can be found [here](https://code.visualstudio.com/docs/editor/tasks).

**Start local runtime:** To start local runtime, a task called `Local Runtime - Up` is available. This task runs the runtime services in the correct order. You can run this task by clicking `F1` and choose `Tasks: Run task`, then select `Local Runtime - Up`.

**Tasks Management:** Visual Studio Code offers various other commands concerning tasks like Start/Terminate/Restart/... You can access them by pressing F1 and typing `task`. A list with available task commands will appear.

**Logging:** Running tasks appear in the Terminals View of Visual Studio Code. From there, you can see the logs of each running task. More detailed logs can be found inside your workspace's logs directory `./logs/*`

## Add/Change runtime service configuration

The configuration for services of our provided local runtime are defined in the [`runtime.json`](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/runtime.json) at the root of the repository [devenv-runtimes](https://github.com/eclipse-velocitas/devenv-runtimes/tree/main).
For a more detailed view on how to change or add runtime service configuration, please visit: [Lifecycle Management Package Development](/docs/concepts/lifecycle_management/packages/development/#configuration-of-runtime-packages)

## Using KUKSA Data Broker CLI

A CLI tool is provided for interacting with a running instance of the KUKSA Data Broker. It can be started by running the task `Local Runtime - VehicleDataBroker CLI`(by pressing _F1_, type _Run Task_ followed by `Local Runtime - VehicleDataBroker CLI`). The _Runtime Local_ needs to be running for you to be able to use the tool.

## Integrating a new runtime service into Visual Studio Code Task

Integration of a new runtime service can be done by duplicating one of the existing tasks.

- Create a new service in either a new created _Package_ or branch/fork of [devenv-runtimes](https://github.com/eclipse-velocitas/devenv-runtimes/tree/main) as already explained above
- In `.vscode/tasks.json`, duplicate section from task e.g. `Local Runtime - Up`, `Local Runtime - Run VehicleApp` or `Local Runtime - VehicleDataBroker CLI`
- Correct names in a new code block
- **Disclaimer:** `Problem Matcher` defined in `tasks.json` is a feature of the Visual Studio Code Task, to ensure that the process runs in background
- Run task using `[F1 -> Tasks: Run Task -> <Your new task label>]`
- Task should be visible in Terminal section of Visual Studio Code

### Task CodeBlock helper

```json
{
    "label": "<task_name>",
    "detail": "<task_description>",
    "type": "shell",
    "command": [
        "velocitas exec runtime-local <service_id> <args>"
    ],
    "presentation": {
        "close": true,
        "reveal": "never"
    },
    "problemMatcher": []
}
```

## Troubleshooting

**Problem description:** When integrating new services into an existing dev environment, it is highly recommended to use the Visual Studio Code Task Feature.
A new service can be easily started by calling it from bash script, however restarting the same service might lead to port conflicts (GRPC Port or APP port). That can be easily avoided by using the Visual Studio Code Task Feature.

### Codespaces

If you are using Codespaces, remember that you are working on a remote agent. That's why it could happen that the tasks are already running in the background. If that's the case a new start of the tasks will fail, since the ports are already in use. In the Dapr-tab of the sidebar you can check if there are already tasks running. Another possibility to check if the processes are already running, is to check which ports are already open. Check the Ports-tab to view all open ports (if not already open, hit `F1` and enter `View: Toggle Ports`).

## Next steps

- Tutorial: [Deploy runtime services in local Kubernetes cluster](/docs/tutorials/run_runtime_services_kubernetes.md)
- Tutorial: [Setup and Explore Development Environment](/docs/tutorials/quickstart)
- Concept: [Deployment Model](/docs/about/deployment-model/)
- Concept: [Build and release process](/docs/about/deployment-model/vehicle_app_releases/)
- Tutorial: [Deploy a Python Vehicle App with Helm](/docs/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm.md)
