---
title: "Quickstart"
date: 2022-05-09T13:43:25+05:30
weight: 1
description: >
  Learn how to setup and explore the provided development environment.
aliases:
  - /docs/tutorials/quickstart.md
---

This page describes

- how to create a GitHub repository for your _Vehicle App_ development,
- how to set up and configure the [DevContainer-based development environment](https://code.visualstudio.com/docs/remote/containers), and
- how to build, customize and test the sample _Vehicle App_ included in your freshly created _Vehicle App_ repository.

You will learn how to use the _Vehicle App_ SDK, interact with the Vehicle API and work with CI/CD using the pre-configured GitHub Workflows that come with the template repository.

Once you have completed all steps, you will have a solid understanding of the development workflow, and you will be able to use one of our template repositories as a starting point for your own _Vehicle App_ development project.

{{% alert title="Note" %}}
Before you start, we recommend familiarizing yourself with our [Basic Concept](/docs/concepts/development_model) to understand all mentioned terms.
{{% /alert %}}

## Prerequisites

Please make sure you did all the prerequisite steps to create comprehensive development environment for your _Vehicle App_:

- Install [VS Code](https://code.visualstudio.com)
- [Install a working container runtime](/docs/tutorials/quickstart/container_runtime)
- Add the [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension to VS Code via the marketplace or using the command line:

   ```bash
   code --install-extension ms-vscode-remote.remote-containers
   ```

## How to create your _Vehicle App_ repository?

For your (GitHub) organization and _Vehicle App_ repository the name _MyOrg/MyFirstVehicleApp_ is used as a place holder during the rest of the document.

You can create your own repository using one of our provided templates or start prototyping via digital.auto.

{{< tabpane text=true >}}
   {{% tab header="Using Template" %}}

Create your own repository copy from the template repository of your choice:

- [Python](https://github.com/eclipse-velocitas/vehicle-app-python-template)
- [C++](https://github.com/eclipse-velocitas/vehicle-app-cpp-template)

by clicking the green button <kbd>Use this template</kbd>. You don't have to include all branches. For more information on Template Repositories take a look at this [GitHub Tutorial](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template).

   {{% /tab %}}
   {{% tab header="digital.auto" %}}
   To learn how to start prototyping with the playground of digital.auto and integrate it into Velocitas please take a look [here](/docs/tutorials/prototyping/digital_auto.md).
   {{% /tab %}}
{{< /tabpane >}}

## How to start developing?

In this section you will learn different possibilities to start developing based on your repository. Basically you can work on your own machine using VS Code's [DevContainer](https://code.visualstudio.com/docs/remote/create-dev-container#:~:text=%20Create%20a%20development%20container%20%201%20Path,additional%20software%20in%20your%20dev%20container.%20More%20) or you can set up the environment on a remote agent, using [GitHub Codespaces](https://github.com/features/codespaces).

{{< tabpane text=true >}}
{{% tab header="VS Code" text=true %}}

The VS Code DevContainer makes it possible to package a complete _Vehicle App_ development environment, including VS Code extensions, [_Vehicle App_ SDK](/docs/concepts/development_model/vehicle_app_sdk/), [_Vehicle App_ Runtimes](/docs/tutorials/vehicle_app_runtime) and all other development and testing tools into a container which is started directly in VS Code.

{{% pageinfo color="primary" %}}
***Proxy Configuration***

A non proxy configuration is used by default. If you are working behind a corporate proxy you will need to specify proxy settings: [Working behind a proxy](/docs/tutorials/quickstart/behind_proxy)
{{% /pageinfo %}}

With following steps you will clone and set up your development environment on your own machine using VS Code.

1. Clone created _MyOrg/MyFirstVehicleApp_ repository locally using your favorite Git tool
1. Switch the directory to the cloned repository folder, e.g. ```$ cd MyFirstVehicleApp```
1. Open the repository in VS Code via ```$ code .``` or via [VS Code user interface](https://code.visualstudio.com/docs/editor/workspaces#_singlefolder-workspaces).
1. A popup appears in the lower right corner with the button <kbd>Reopen in Container</kbd>.
1. Click on <kbd>Reopen in Container</kbd>. If the popup does not appear, you can also hit <kbd>F1</kbd> and perform the command `Dev-Containers: Reopen in Container`
1. Wait for the container to be set up

The first initializing of the container will take some minutes to build the image and provision all the integrated tools.

{{% pageinfo color="primary" %}}
If the _DevContainer_ build process fails, press <kbd>F1</kbd> and run the command `Dev-Containers: Rebuild Container Without Cache`.
The _DevContainer_ is using the [docker-in-docker](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/docker-in-docker.md) feature to run docker containers within the container.
{{% /pageinfo %}}

{{% /tab %}}
{{% tab header="GitHub Codespaces" text=true %}}
One of the possibilities to use your newly created repository is to use it inside a [GitHub Codespace](https://github.com/features/codespaces).
You can either try it out directly in the browser or also use it inside VS Code. The main thing to remember is that everything is executed on a remote agent and the browser or VS Code just acts as a "thin-client".

To get started with GitHub Codespaces, you just have to follow a few steps:

1. Open your repository on GitHub (e.g. <https://github.com/MyOrg/MyFirstVehicleApp>)
1. Click on the green `Code` button and select _Codespaces_ on the top
1. Configure your _Codespace_ if needed (defaults to the main branch and a standard agent)
1. Click on `create`

A new window will open where you can see logs for setting up the container. On this window you could now also choose to work with VS Code. The environment remains on a remote agent and VS Code establishes a connection to this machine.

Once everything is set up in the _Codespace_, you can work with it in the same way as with the normal DevContainer inside VS Code.

{{% pageinfo color="primary" %}}
Be careful with using GitHub Codespaces in a browser and VS Code locally at the same time: _Tasks_ that are started using a browser session will not show in VS Code environment and vice versa. This might lead to problems.
{{% /pageinfo %}}

{{% /tab %}}
{{< /tabpane >}}

You can find more information about the _Vehicle App_ development in the [respective pages](/docs/tutorials/vehicle_app_development).

## How to start the runtime services?

The runtime services (like _KUKSA Data Broker_ or _Vehicle Services_) are required to develop _Vehicle Apps_ and run integration tests.

Currently, the supported options to run these services is either [locally](/docs/tutorials/vehicle_app_runtime/local_runtime), in a [Kubernetes (K3D) cluster](/docs/tutorials/vehicle_app_runtime/kubernetes_runtime) or via the [Kanto runtime](/docs/tutorials/vehicle_app_runtime/kanto_runtime).

{{< tabpane text=true >}}
   {{% tab header="Local Runtime" %}}

A VS Code task called `Local Runtime - Up` is available to start all necessary services in the correct order.

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `Local Runtime - Up`

You should see the task `Local Runtime - Up` being executed on a separate VS Code terminal with the following content:

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
To stop the runtime simply press `Ctrl + C`.
{{% /pageinfo %}}

{{% /tab %}}
{{% tab header="K3D Runtime" %}}

A VS Code task called `K3D Runtime - Up` is available to start all necessary services in the correct order.

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `K3D Runtime - Up`

You should see the task `K3D Runtime - Up` being executed on a separate VS Code terminal with the following content:

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
   You need to perform the task `K3D Runtime - Down` to properly stop all runtime activities.
{{% /pageinfo %}}

{{% /tab %}}
   {{% tab header="Kanto Runtime" %}}

A VS Code task called `Kanto Runtime - Up` is available to start all necessary services in the correct order.

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `Kanto Runtime - Up`

You should see the task `Kanto Runtime - Up` being executed on a separate VS Code terminal with the following content:

```bash
$ velocitas exec runtime-kanto up

Hint: Log files can be found in your workspace's logs directory
> Checking Kanto registry... registry already exists.
> Checking Kanto registry... starting registry.
> Checking Kanto registry... started.
✅ Configuring controlplane for Kanto...
⠇ Starting Kanto...waiting
✅ Kanto is ready to use!
```

{{% pageinfo color="primary" %}}
To stop the runtime simply press `Ctrl + C` or execute the task `Kanto Runtime - Down`.
{{% /pageinfo %}}

{{% /tab %}}
{{< /tabpane >}}

More information about the runtimes are available [here](/docs/tutorials/vehicle_app_runtime).

## How to debug your _Vehicle App_?

{{% alert title="Warning" %}}
Debugging functionality is only available when using the [Local Runtime](/docs/tutorials/vehicle_app_runtime/local_runtime).
Both given examples are available as part of template.
{{% /alert %}}

Now that the [runtime services](/docs/tutorials/vehicle_app_runtime/local_runtime) are all up and running, let's start a debug session for the _Vehicle App_.

{{< tabpane text=true >}}
{{% tab header="Python" %}}

1. Open the main source file  `/app/src/main.py` and set a breakpoint in the given method `on_get_speed_request_received`
1. Press <kbd>F5</kbd> to start a debug session of the _Vehicle App_ and see the log output on the `DEBUG CONSOLE`

To trigger this breakpoint, let's send a message to the _Vehicle App_ using the mqtt broker that is running in the background.

1. Open `VSMqtt` extension in VS Code and connect to `mosquitto (local)`
1. Set `Subscribe Topic` = `sampleapp/getSpeed/response` and click subscribe
1. Set `Publish Topic` = `sampleapp/getSpeed`
1. Press publish with an empty payload field.
{{% /tab %}}
{{% tab header="C++" %}}

1. Open the main source file `/app/src/VehicleApp.cpp` and set a breakpoint in the given method `onSetPositionRequestReceived`
1. Press <kbd>F5</kbd> to start a debug session of the _Vehicle App_ and see the log output on the `DEBUG CONSOLE`

To trigger this breakpoint, let's send a message to the _Vehicle App_ using the mqtt broker that is running in the background.

1. Open `VSMqtt` extension in VS Code and connect to `mosquitto (local)`
1. Set `Subscribe Topic` = `seatadjuster/setPosition/response` and click subscribe
1. Set `Subscribe Topic` = `seatadjuster/currentPosition` and click subscribe
1. Set `Publish Topic` = `seatadjuster/setPosition/request`
1. Set and publish a dummy payload: `{ "position": 300, "requestId": 123 }`

{{% /tab %}}
{{< /tabpane >}}
Now your breakpoint in the _Vehicle App_ gets hit and you can inspect everything in your debug session. After resuming execution (<kbd>F5</kbd>), a response from your _Vehicle App_ is published to the response topic. You can see the response in the MQTT window.

## How to trigger the CI Workflow?

The provided GitHub workflows are used to build the container image for the _Vehicle App_, run unit and integration tests and collect the test results.

The CI Workflow will be triggered by pushing a change to the main branch of your repository:

1. Make modification in any of your files
1. Navigate in your terminal to your repository
1. Commit and push your change

   ```bash
   git add .
   git commit -m "<explain your changes>"
   git push origin
   ```

To see the results open the `Actions` page of your repository on GitHub, go to `CI Workflow` and check the workflow output.

## How to release your _Vehicle App_?

Now that the `CI Workflow` was successful, you are ready to build your first release. The goal is to build a ready-to-deploy container image that is published in the GitHub container registry.

1. Open the `Code` page of your repository on GitHub
1. Click on `Create a new release` in the Releases section on the right side
1. Enter a version (e.g. v1.0.0) and click on `Publish release`
   - GitHub will automatically create a tag using the version number

The provided release workflow will be triggered by the release. It creates a release documentation and publishes the container image of the _Vehicle App_ to the GitHub container registry. A detailed description of the workflow can be found [here](/docs/concepts/deployment_model/vehicle_app_releases/).

## How to deploy your _Vehicle App_?

After releasing the _Vehicle App_ to the GitHub container registry you might ask how to bring the _Vehicle App_ and the required runtime stack on a device. Here, _Eclipse Leda_ comes into the game.

Please read the documentation of [Eclipse Leda](https://eclipse-leda.github.io/leda/docs/app-deployment/velocitas/) to get more information.

## Next steps

- Tutorial: [Creating a Vehicle Model](/docs/tutorials/vehicle_model_creation)
- Tutorial: [Create a Vehicle App](/docs/tutorials/vehicle_app_development)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/vehicle_app_development/integration_tests)
