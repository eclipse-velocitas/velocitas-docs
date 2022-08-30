---
title: "Quickstart"
date: 2022-05-09T13:43:25+05:30
weight: 1
description: >
  Learn how to setup and explore the provided development environment.
aliases:
  - /docs/tutorials/setup_and_explore_development_environment.md
  - /docs/tutorials/quickstart.md
  - /docs/setup_and_explore_development_environment.md
---

The following information describes how to setup and configure the [Development Container (DevContainer)](https://code.visualstudio.com/docs/remote/containers), and how to build, customize and test the sample _Vehicle App_, which is included in this repository. You will learn how to use the Vehicle App SDK, how to interact with the vehicle API and how to do CI/CD using the pre-configured GitHub workflows that come with the repository.

Once you have completed all steps, you will have a solid understanding of the Development Workflow and you will be able to reuse the [Template Repository](https://github.com/eclipse-velocitas/vehicle-app-python-template) for your own _Vehicle App_ develpment project.

{{% alert title="Note" %}}
Before you start, we recommend that you familiarize yourself with our [basic concept](/docs/about/development_model) to understand the terms mentioned.
{{% /alert %}}

## Creating Vehicle App Repository

For the orginization and _Vehicle App_ repository the name `MyOrg/MyFirstVehicleApp` is used as a reference during the rest of the document.

{{< tabpane text=true >}}
{{% tab header="Python" %}}
Create your own repository copy from the [Template Repository](https://github.com/eclipse-velocitas/vehicle-app-python-template) by clicking the green button `Use this template`. You don't have to include all branches. For more information on Template Repositories take a look at this [GitHub Tutorial](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template).
{{% /tab %}}
{{% tab header="C++" %}}
C++ currently has only an [SDK repository](https://github.com/eclipse-velocitas/vehicle-app-cpp-sdk). To create your own _Vehicle App_ repository, fork the repository into your own organization. For the fork, only the `main` branch needs to be copied over.
{{% /tab %}}
{{< /tabpane >}}

## Starting Development Environment

In the following you will learn different possibilities to work with the repo. Basically you can work on your own machine using just Visual Studio Code or you can set up the environment on a remote agent, using [GitHub Codespaces](https://github.com/features/codespaces).

### Visual Studio Code

The Visual Studio Code [Development Containers](https://code.visualstudio.com/docs/remote/create-dev-container#:~:text=%20Create%20a%20development%20container%20%201%20Path,additional%20software%20in%20your%20dev%20container.%20More%20) makes it possible to package a complete Vehicle App development environment, including Visual Studio Code extensions, Vehicle App SDK, Vehicle App runtime and all other development & testing tools into a container that is then started within your Visual Studio Code session.

To be able to use the DevContainer, you have to make sure that you fulfill the following prerequisites:

- Install Docker Engine / [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Install [Visual Studio Code](https://code.visualstudio.com)
- Add [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension via the marketplace or using the command line

  ```bash
  code --install-extension ms-vscode-remote.remote-containers
  ```

{{% alert title="Proxy configuration" color="warning" %}}
A non proxy configuration is used by default. If you are working behind a corporate proxy you will need to specify proxy settings: [Working behind a proxy](/docs/tutorials/quickstart/behind_proxy)
{{% /alert %}}

With following steps you will clone and set up your development environment on your own machine using just Visual Studio Code.

1. Start Visual Studio Code
2. Press <kbd>F1</kbd> and run the command `Remote-Containers: Clone Repository in Container Volume...`
3. Select `Clone a repository from GitHub in a Container Volume` and choose the repository / branch to clone
4. Enter the GitHub organization and repository name (e.g. `MyOrg/MyFirstVehicleApp`) and select the repository from the list
5. Select the branch to clone from the list

The first time initializing the container will take a few minutes to build the image and to provision the tools inside the container.
  
{{% alert title="Note" %}}
When opening the DevContainer for the first time, a manual reload of the dapr extension is required, if the extension hasn´t been installed before. The reload button appears next to Dapr extension in extension menue.
{{% /alert %}}

<details>
<summary>Please expand for information on troubleshooting</summary>

> If Visual Studio Code [fails to directly clone your repository](https://github.com/microsoft/vscode-dev-containers/issues/1585)  you can also use a workaround:
>
> 1. Clone the repo locally using your favorite Git tooling
> 1. Start Visual Studio Code
> 1. Select `Open Folder` from the `File` menu
> 1. Open the root of the cloned repo
> 1. A popup appears on the lower left side of Visual Studio Code
> 1. Click on `Reopen in Container`
> 1. Wait for the container to be set up
>
> If the popup does not appear, you can also hit <kbd>F1</kbd> and run the command `Remote-Containers: Open Folder in Container`

> If the development container fails to build successfully (e.g. due to network issues), then wait for the current build to finish, press <kbd>F1</kbd> and run the command `Remote-Containers: Rebuild Container Without Cache`

The devContainer is using the [docker-in-docker](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/docker-in-docker.md)-feature to run docker containers within the container. Currently, this feature has the limitation that only one instance of a devContainer with the feature enabled can be running at the same time.

</details>

### Codespaces

Another possibility to use your newly created repository is via [GitHub Codespaces](https://github.com/features/codespaces).
You can either try it out directly in the browser or also use it inside Visual Studio Code. The main thing to remember is that everything is executed on a remote agent and the browser or Visual Studio Code just act as frontends.

To get started with Codespaces, you just have to follow a few steps:

1. Open your repository on GitHub (e.g. <https://github.com/MyOrg/MyFirstVehicleApp>)
1. Click on the green `Code` button and select Codespaces on the top
1. Configure your Codespace if needed (defaults to the main branch and a standard agent)
1. Click on `create`

A new window will open where you see the logs for setting up the container. On this window you could now also choose to work with Visual Studio Code. The environment remains on a remote agent and Visual Studio Code establishes a connection to this machine.

Once everything is set up in the Codespace, you can work with it in the same way as with the normal DevContainer inside Visual Studio Code.

{{% alert title="Note" %}}
Be careful with using Codespaces in browser and Visual Studio Code locally at the same time: _Tasks_ that are started using a browser session will not show in Visual Studio Code environment and vice versa. This can lead to problems using the prepared _Tasks_-scripts.
{{% /alert %}}

## Starting runtime services

The runtime services (like _KUKSA Data Broker_ or _Vehicle Services_) are required to develop vehicle apps and run integration tests.

A Visual Studio Code task called `Start Vehicle App runtime` is available to run these in the correct order.

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `Start VehicleApp runtime`
4. Choose `Continue without scanning the output`

You should see the tasks `run-mosquitto`, `run-vehicledatabroker`, `run-vehicleservices` and `run-feedercan` being executed in the Visual Studio Code output panel.

More information about the tasks are available [here](/docs/run_runtime_services_locally.md).

## Debugging Vehicle App

Now that the [runtime services](#starting-runtime-services) are all up and running, let's start a debug session for the Vehicle App as next step.

{{< tabpane text=true >}}
{{% tab header="Template" %}}

1. Open the main source file and set a breakpoint in the given method:
   - Python main source file: `/app/src/main.py`, set breakpoint in method: `on_get_speed_request_received`
   - C++: Continue on the `Seat Adjuster` tab.
2. Press <kbd>F5</kbd> to start a debug session of the _Vehicle App_ and see the log output on the `DEBUG CONSOLE`

To trigger this breakpoint, let's send a message to the Vehicle App using the mqtt broker that is running in the background.

3. Open `VSMqtt` extension in Visual Studio Code and connect to `mosquitto (local)`
4. Set `Subscribe Topic` = `myvehicleapp/getSpeed/response` and click subscribe
6. Set `Publish Topic` = `myvehicleapp/getSpeed`
7. Press publish with an empty payload field.
{{% /tab %}}
{{% tab header="Seat Adjuster" %}}

For Python: Follow the guide provided in: [Import examples](/docs/tutorials/quickstart/import_examples/) and import [`seat-adjuster`](https://github.com/eclipse-velocitas/vehicle-app-python-sdk/tree/main/examples/seat-adjuster). </br>
For C++: Continue with the next steps.

1. Open the main source file and set a breakpoint in the given method:
   - Python main source file: `/app/src/main.py`, set breakpoint in method: `on_set_position_request_received`
   - C++ main source file: `/app/src/VehicleApp.cpp`, set breakpoint in method: `onSetPositionRequestReceived`
2. Press <kbd>F5</kbd> to start a debug session of the _Vehicle App_ and see the log output on the `DEBUG CONSOLE`

To trigger this breakpoint, let's send a message to the Vehicle App using the mqtt broker that is running in the background.

3. Open `VSMqtt` extension in Visual Studio Code and connect to `mosquitto (local)`
4. Set `Subscribe Topic` = `seatadjuster/setPosition/response` and click subscribe
5. Set `Subscribe Topic` = `seatadjuster/currentPosition` and click subscribe
6. Set `Publish Topic` = `seatadjuster/setPosition/request`
7. Set and publish a dummy payload:

   ```json
   { "position": 300, "requestId": "xyz" }
   ```

{{% /tab %}}
{{< /tabpane >}}
Now your breakpoint in the Vehicle App gets hit and you can inspect everything in your debug session. After resuming execution (<kbd>F5</kbd>), a response from your Vehicle App is published to the response topic. You can see the response in the MQTT window.

## Triggering CI Workflow

The provided GitHub workflows are used to build the container image for the Vehicle App, run unit and integration tests, collect the test results and create a release documentation and publish the Vehicle App. A detailed description of the workflow you can find [here](https://github.com/eclipse-velocitas/velocitas-docs/blob/main/docs/vehicle_app_releases.md).
  
By pushing a change to GitHub the CI Workflow will be triggered:

1. Make modification in any of your files
2. Commit and push your change

   ```bash
   git add .
   git commit -m "removed emtpy line"
   git push
   ```

To see the results open the `Actions` page of your repository on GitHub, go to `CI Workflow` and check the workflow output.

## Releasing Vehicle App

Now that the `CI Workflow` was successful, you are ready to build your first release. Your goal is to build a ready-to-deploy container image that is published in the GitHub container registry

1. Open the `Code` page of your repository on GitHub
1. Click on `Create a new release` in the Releases section on the right side
1. Enter a version, e.g. v1.0.0, and click on `Publish release`
   - GitHub will automatically create a tag using the version number

The provided release workflow will be triggered by the release. The release workflow creates a release documentation and publish the container image of the Vehicle App to the GitHub container registry. Open `Actions` on the repoitory and see the result.

## Next steps

- Tutorial: [Creating a Vehicle Model](/docs/tutorials/tutorial_how_to_create_a_vehicle_model)
- Tutorial: [Create a Vehicle App](/docs/tutorials/vehicle-app-development)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/integration_tests.md)
