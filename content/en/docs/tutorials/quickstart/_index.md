---
title: "Getting Started"
date: 2022-05-09T13:43:25+05:30
weight: 10
description: >
  Learn how to setup and explore the provided development environment.
aliases:
  - /docs/tutorials/setup_and_explore_development_environment.md
  - /docs/tutorials/quickstart.md
  - /docs/getting_started
  - /docs/setup_and_explore_development_environment.md
---

The following page describes how to set up and configure the [Development Container (DevContainer)](https://code.visualstudio.com/docs/remote/containers) and how to build, customize and test the sample _Vehicle App_ included in this repository. You will learn how to use the Vehicle App SDK, interact with the vehicle API and work with CI/CD using the pre-configured GitHub Workflows that come with the template repository.

Once you have completed all steps, you will have a solid understanding of the Development Workflow, and you will be able to reuse the [Template Repository](https://github.com/eclipse-velocitas/vehicle-app-python-template) for your own _Vehicle App_ development project.

{{% alert title="Note" %}}
Before you start, we recommend you familiarize yourself with our [Basic Concept](/docs/concepts/development_model) to understand mentioned terms.
{{% /alert %}}

## Prerequisites

Following is required to create comprehensive Development Environment for your _Vehicle App_:

- Install [VSCode](https://code.visualstudio.com)
- [Install a working container runtime](/docs/tutorials/quickstart/container_runtime)
- Add [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension via the marketplace or using the command line

   ```bash
   code --install-extension ms-vscode-remote.remote-containers
   ```

## How to create _Vehicle App_ Repository?

For the Organization and Vehicle App repository the name _MyOrg/MyFirstVehicleApp_ is used as a reference during the rest of the document.

You can create your own repository using template directly or starting from prototyping via Digital.Auto.

{{< tabpane text=true >}}
   {{% tab header="Using Template" %}}

Create your own repository copy from the template repository of your choice [Python](https://github.com/eclipse-velocitas/vehicle-app-python-template)/[C++](https://github.com/eclipse-velocitas/vehicle-app-cpp-template) by clicking the green button <kbd>Use this template</kbd>. You don't have to include all branches. For more information on Template Repositories take a look at this [GitHub Tutorial](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template).

   {{% /tab %}}
   {{% tab header="Digital.Auto" %}}
   To learn how to start a prototype with the playground of Digital.Auto and integrate it into Velocitas please follow the [link](/docs/tutorials/prototyping)
   {{% /tab %}}
{{< /tabpane >}}

## How to start to develop?

In the following chapter you will learn different possibilities to start developing based on your repository. Basically you can work on your own machine using just VSCode's [DevContainer](https://code.visualstudio.com/docs/remote/create-dev-container#:~:text=%20Create%20a%20development%20container%20%201%20Path,additional%20software%20in%20your%20dev%20container.%20More%20) or you can set up the environment on a remote agent, using [GitHub Codespaces](https://github.com/features/codespaces).

**Prerequisites**: Your _Vehicle App_ repository based on template is [created](#how-to-create-vehicle-app-repository).

{{< tabpane text=true >}}
{{% tab header="VSCode" text=true %}}

The VSCode's DevContainer makes possible to package a complete _Vehicle App_ development environment, including VSCode's extensions, [Vehicle App SDK](/docs/concepts/development_model/vehicle_app_sdk/), [Vehicle App Runtimes](/docs/tutorials/vehicle-app-runtime) and all other development and testing tools into a DevContainer that is then started within your VSCode session.

{{% pageinfo color="primary" %}}
***Proxy Configuration***

A non proxy configuration is used by default. If you are working behind a corporate proxy you will need to specify proxy settings: [Working behind a proxy](/docs/tutorials/quickstart/behind_proxy)
{{% /pageinfo %}}

With following steps you will clone and set up your development environment on your own machine using just VSCode.

1. Clone created _MyOrg/MyFirstVehicleApp_ repository locally using your favorite Git Tool
1. Go to the just cloned repository folder, e.g. ```$ cd MyFirstVehicleApp```
1. Open VSCode with project content like ```$ code .``` or via [VSCode user interface](https://code.visualstudio.com/docs/editor/workspaces#_singlefolder-workspaces).
1. A popup appears with the button <kbd>Reopen in Container</kbd> on the lower right side of VSCode. If the popup does not appear, you can also hit <kbd>F1</kbd> and perform the command `Dev-Containers: Open Folder in Container`
1. Click on <kbd>Reopen in Container</kbd>
1. Wait for the container to be set up

The first time initializing the container will take few minutes to build the image and to provision the tools inside the container.

{{% pageinfo color="primary" %}}
If the _DevContainer_ build process fails, then wait for the current build to finish, press <kbd>F1</kbd> and run the command `Dev-Containers: Rebuild Container Without Cache`
The _DevContainer_ is using the [docker-in-docker](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/docker-in-docker.md) feature to run docker containers within the container. Currently, this feature has the limitation that only one instance of a _DevContainer_ with the feature enabled can be running at the same time.
{{% /pageinfo %}}

{{% /tab %}}
{{% tab header="GitHub Codespaces" text=true %}}
One of the possibilities to use your newly created repository to use it via [GitHub Codespaces](https://github.com/features/codespaces).
You can either try it out directly in the browser or also use it inside VSCode. The main thing to remember is that everything is executed on a remote agent and the browser or VSCode just act as a "thin-client".

To get started with GitHub Codespaces, you just have to follow a few steps:

1. Open your repository on GitHub (e.g. <https://github.com/MyOrg/MyFirstVehicleApp>)
1. Click on the green `Code` button and select _Codespaces_ on the top
1. Configure your _Codespace_ if needed (defaults to the main branch and a standard agent)
1. Click on `create`

A new window will open where you can see logs for setting up the container. On this window you could now also choose to work with VSCode. The environment remains on a remote agent and VSCode establishes a connection to this machine.

Once everything is set up in the _Codespace_, you can work with it in the same way as with the normal DevContainer inside VSCode.

{{% pageinfo color="primary" %}}
Be careful with using GitHub Codespaces in browser and VSCode locally at the same time: _Tasks_ that are started using a browser session will not show in VSCode environment and vice versa that leads for problems.
{{% /pageinfo %}}

{{% /tab %}}
{{< /tabpane >}}

## How to start runtimes?

The runtime services (like _KUKSA Data Broker_ or _Vehicle Services_) are required to develop vehicle apps and run integration tests.

There are few runtimes available currently:

{{< tabpane text=true >}}
   {{% tab header="Local Runtime" %}}

A VSCode task called `Local Runtime - Up` is available to start all necessary services in the correct order.

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `Local Runtime - Up`

You should see the task `Local Runtime - Up` being executed on a separate VSCode terminal with the following content:

```bash
$ velocitas exec runtime-local up

Hint: Log files can be found in your workspace's logs directory
> mqtt-broker running
> vehicledatabroker running
> seatservice running
> feedercan running
✅ Runtime is ready to use!
```

{{% pageinfo color="primary" %}}
Simply press `Ctrl + C` to stop the runtime.
{{% /pageinfo %}}

{{% /tab %}}
{{% tab header="K3D Runtime" %}}

A VSCode task called `K3D Runtime - Up` is available to start all necessary services in the correct order.

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `K3D Runtime - Up`

You should see the task `K3D Runtime - Up` being executed on a separate VSCode terminal with the following content:

```bash
$ velocitas exec runtime-k3d up

Hint: Log files can be found in your workspace's logs directory
> Checking K3D registry... created.
> Creating cluster with proxy configuration.
> Checking K3D cluster... created.
> Checking zipkin deployment... deployed.
> Checking dapr... initialized.
✅ Configuring controlplane for k3d...
> Deploying runtime... installed.
✅ Starting k3d runtime...
```

{{% pageinfo color="primary" %}}
   You need to perform task `K3D Runtime - Down` to properly stop runtime activities.
{{% /pageinfo %}}

{{% /tab %}}
{{< /tabpane >}}

More information about the runtimes are available [here](/docs/tutorials/vehicle-app-runtime).

## How to debug _Vehicle App_?

{{% alert title="Warning" %}}
Debugging functionality is available only for [Local Runtime](/docs/tutorials/run_runtime_services_locally)
Both given examples are available as part of template.
{{% /alert %}}

Now that the [runtime services](/docs/tutorials/run_runtime_services_locally) are all up and running, let's start a debug session for the _Vehicle App_ as next step.

{{< tabpane text=true >}}
{{% tab header="Template" %}}

1. Open the main source file and set a breakpoint in the given method:
   - Python main source file: `/app/src/main.py`, set a breakpoint inside the method: `on_get_speed_request_received`
   - C++: Continue on the `Seat Adjuster` tab.
1. Press <kbd>F5</kbd> to start a debug session of the _Vehicle App_ and see the log output on the `DEBUG CONSOLE`

To trigger this breakpoint, let's send a message to the Vehicle App using the mqtt broker that is running in the background.

1. Open `VSMqtt` extension in VSCode and connect to `mosquitto (local)`
1. Set `Subscribe Topic` = `sampleapp/getSpeed/response` and click subscribe
1. Set `Publish Topic` = `sampleapp/getSpeed`
1. Press publish with an empty payload field.
{{% /tab %}}
{{% tab header="Seat Adjuster" %}}

For Python: Follow the guide provided in: [Import examples](/docs/tutorials/quickstart/import_examples/) and import [`seat-adjuster`](https://github.com/eclipse-velocitas/vehicle-app-python-sdk/tree/main/examples/seat-adjuster). </br>
For C++: Continue with the next steps.

1. Open the main source file and set a breakpoint in the given method:
   - Python main source file: `/app/src/main.py`, set breakpoint in method: `on_set_position_request_received`
   - C++ main source file: `/app/src/VehicleApp.cpp`, set breakpoint in method: `onSetPositionRequestReceived`
1. Press <kbd>F5</kbd> to start a debug session of the _Vehicle App_ and see the log output on the `DEBUG CONSOLE`

To trigger this breakpoint, let's send a message to the Vehicle App using the mqtt broker that is running in the background.

1. Open `VSMqtt` extension in VSCode and connect to `mosquitto (local)`
1. Set `Subscribe Topic` = `seatadjuster/setPosition/response` and click subscribe
1. Set `Subscribe Topic` = `seatadjuster/currentPosition` and click subscribe
1. Set `Publish Topic` = `seatadjuster/setPosition/request`
1. Set and publish a dummy payload:

   ```json
   { "position": 300, "requestId": "xyz" }
   ```

{{% /tab %}}
{{< /tabpane >}}
Now your breakpoint in the Vehicle App gets hit and you can inspect everything in your debug session. After resuming execution (<kbd>F5</kbd>), a response from your Vehicle App is published to the response topic. You can see the response in the MQTT window.

## How to trigger CI Workflow?

The provided GitHub workflows are used to build the container image for the Vehicle App, run unit and integration tests, collect the test results and create a release documentation and publish the Vehicle App. A detailed description of the workflow you can find [here](/docs/concepts/deployment_model/vehicle_app_releases/).

By pushing a change to GitHub the CI Workflow will be triggered:

1. Make modification in any of your files
2. Commit and push your change

   ```bash
   git add .
   git commit -m "<explain your changes>"
   git push
   ```

To see the results open the `Actions` page of your repository on GitHub, go to `CI Workflow` and check the workflow output.

## How to release _Vehicle App_?

Now that the `CI Workflow` was successful, you are ready to build your first release. Your goal is to build a ready-to-deploy container image that is published in the GitHub container registry

1. Open the `Code` page of your repository on GitHub
1. Click on `Create a new release` in the Releases section on the right side
1. Enter a version (e.g. v1.0.0) and click on `Publish release`
   - GitHub will automatically create a tag using the version number

The provided release workflow will be triggered by the release. The release workflow creates a release documentation and publish the container image of the Vehicle App to the GitHub container registry. Open `Actions` on the repository and see the result.

## How to deploy _Vehicle App_?

After releasing the Vehicle App to the GitHub container registry you might ask how to bring the Vehicle App on a device and have the required Runtime Stack on the device. Here _Eclipse Leda_ comes into the game.

Please checkout the documentation of [Eclipse Leda](https://eclipse-leda.github.io/leda/docs/app-deployment/velocitas/) to get more information.

## Next steps

- Tutorial: [Creating a Vehicle Model](/docs/tutorials/vehicle_model_creation)
- Tutorial: [Create a Vehicle App](/docs/tutorials/vehicle-app-development)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/integration_tests)
