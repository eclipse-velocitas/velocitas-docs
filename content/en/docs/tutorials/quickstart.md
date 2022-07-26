---
title: "Quickstart"
date: 2022-05-09T13:43:25+05:30
weight: 1
description: >
  Learn how to setup and explore the provided development environment.
aliases:
  - /docs/tutorials/setup_and_explore_development_environment.md
  - /docs/setup_and_explore_development_environment.md
---

The following information describes how to setup and configure the Development Container (DevContainer), and how to build, customize and test the sample Vehicle App, which is included in this repository. You will learn how to use the Vehicle App SDK, how to interact with the vehicle API and how to do CI/CD using the pre-configured GitHub workflows that come with the repository.

Once you have completed all steps, you will have a solid understanding of the Development Workflow and you will be able to reuse the [Template Repository](https://github.com/eclipse-velocitas/vehicle-app-python-template) for your own Vehicle App develpment project.

## Vehicle App development with Visual Studio Code

The Visual Studio Code [Development Containers](https://code.visualstudio.com/docs/remote/create-dev-container#:~:text=%20Create%20a%20development%20container%20%201%20Path,additional%20software%20in%20your%20dev%20container.%20More%20) makes it possible to package a complete Vehicle App development environment, including Visual Studio Code extensions, Vehicle App SDK, Vehicle App runtime and all other development & testing tools into a container that is then started within your Visual Studio Code session.

To be able to use the DevContainer, you have to make sure that you fulfill the following prerequisites:

### System prerequisites

- Install Docker Engine / [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Install [Visual Studio Code](https://code.visualstudio.com)
- Add [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension via the marketplace or using the command line
  ```
  code --install-extension ms-vscode-remote.remote-containers
  ```

### Proxy configuration

A non proxy configuration is used by default.
If you are working behind a corporate proxy you will need to specify proxy settings.

<details>
<summary>Please expand for information on configuring proxy settings</summary>

A template configuration using proxies exists in `.devcontainer/Dockerfile.Proxy` and by setting the environment variable `DEVCONTAINER_PROXY` to `.Proxy` the file
`.devcontainer/Dockerfile.Proxy` will be used instead of `.devcontainer/Dockerfile`.

The template configuration uses the following default configuration:

```
ENV HTTP_PROXY="http://172.17.0.1:${PROXY_PORT:-3128}"
```

- If your proxy is not available on `172.17.0.1` then you must modify `.devcontainer/Dockerfile.Proxy`.
- If your proxy does not use 3128 as port you can set another port in the environment variable `DEVCONTAINER_PROXY_PORT`

#### Windows:

1. Edit environment variables for your account
2. Create an environment variable with name the `DEVCONTAINER_PROXY` and with the value `.Proxy` for your account
   - Don't forget (dot) in value of the environment variable
3. If you are using a different Port than 3128 for your Proxy, you have to set another environment variable as follows:
   - DEVCONTAINER_PROXY_PORT=<PortNumber>
4. Restart Visual Studio Code to pick up the new environment variable

#### macOS & Linux:

```
echo "export DEVCONTAINER_PROXY=.Proxy" >> ~/.bash_profile
source ~/.bash_profile
```

### Proxy troubleshooting

If you experience issues during initial DevContainer build and you want to start over, then you want to make sure you clean all images and volumes in Docker Desktop, otherwise cache might be used. Use the Docker Desktop UI to remove all volumes and containers.

Proxy settings in `~/.docker/config.json` will override settings in `.devcontainer/Dockerfile.Proxy`, which can cause problems.
In case the DevContainer is still not working, check if proxy settings are set correctly in the Docker user profile (`~/.docker/config.json`), see [Docker Documentation](https://docs.docker.com/network/proxy/) for more details.
Verify that the `noProxy` setting in `~/.docker/config.json` (if existing) is compatible with the setting of `NO_PROXY` in `.devcontainer/Dockerfile.Proxy`.
The development environment relies on communication to localhost (e.g. localhost, 127.0.0.1) and it is important that the proxy setting is correct so that connections to localhost are not forwarded to the proxy.

</details>

## Use Template Repository

Create your own repository copy from the [Template Repository](https://github.com/eclipse-velocitas/vehicle-app-python-template) by clicking the green button `Use this template`. You don't have to include all branches.

The name `MyOrg/MyFirstVehicleApp` is used as a reference during the rest of document.

For more information on Template Repositories take a look at this [GitHub Tutorial](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)

In the following you will learn different possibilities to work with the repo. Basically you can work on your own machine using just Visual Studio Code or you can set up the environment on a remote agent, using [GitHub Codespaces](https://github.com/features/codespaces).

### Visual Studio Code

With following steps you will clone and set up your development environment on your own machine using just Visual Studio Code.

1. Start Visual Studio Code
2. Press <kbd>F1</kbd> and run the command `Remote-Containers: Clone Repository within Container Volume...`
3. Select `Clone a repository from GitHub in a Container Volume` and choose the repository / branch to clone
4. Enter the GitHub organization and repository name (e.g. `MyOrg/MyFirstVehicleApp`) and select the repository from the list
5. Select the branch to clone from the list

The first time initializing the container will take a few minutes to build the image and to provision the tools inside the container.
> When opening the DevContainer for the first time, the following steps are necessary:

- A manual reload of the dapr extension is required, if the extension hasn´t been installed before (Note: the reload button appears next to Dapr extension in extension menue).

<details>
<summary>Please expand for information on troubleshooting</summary>

> If Visual Studio Code fails to directly clone your repository you can also use a workaround:
>
> 1.  clone the repo locally using your favorite Git tooling
> 1.  Start Visual Studio Code
> 1.  select `Open Folder` from the `File` menu
> 1.  open the root of the cloned repo
> 1.  a popup appears on the lower left side of Visual Studio Code
> 1.  click on `Reopen in Container`
> 1.  wait for the container to be set up
>
> If the popup does not appear, you can also hit <kbd>F1</kbd> and run the command `Remote-Containers: Open Folder in Container`

> If the development container fails to build successfully (e.g. due to network issues), then wait for the current build to finish, press <kbd>F1</kbd> and run the command `Remote-Containers: Rebuild Container Without Cache`

The devContainer is using the [docker-in-docker](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/docker-in-docker.md)-feature to run docker containers within the container. Currently, this feature has the limitation that only one instance of a devContainer with the feature enabled can be running at the same time.

</details>

### Codespaces

Another possibility to use your newly created repository is via [GitHub Codespaces](https://github.com/features/codespaces).
You can either try it out directly in the browser or also use it inside Visual Studio Code. The main thing to remember is that everything is executed on a remote agent and the browser or Visual Studio Code just act as frontends.

To get started with Codespaces, you just have to follow a few steps:

1. go to the webpage of your repository on GitHub (e.g. https://github.com/MyOrg/MyFirstVehicleApp)
1. click on the green `Code`-button and select Codespaces on the top
1. configure your Codespace if needed (defaults to the main branch and a standard agent)
1. click on `create`

A new window will open where you see the logs for setting up the container. On this window you could now also choose to work with Visual Studio Code. The environment remains on a remote agent and Visual Studio Code establishes a connection to this machine.

Once everything is set up in the Codespace, you can work with it in the same way as with the normal DevContainer inside Visual Studio Code.

**Note:** Be careful with using Codespaces in browser and Visual Studio Code locally: _Tasks_ that are started using a browser session will not show in Visual Studio Code environment and vice versa. This can lead to problems using the prepared _Tasks_-scripts.

## Starting runtime services

The runtime services (like _KUKSA Data Broker_ or _Vehicle Services_) are required to develop vehicle apps and run integration tests.

A Visual Studio Code task called `Start Vehicle App runtime` is available to run these in the correct order. Click `F1`, select command `Tasks: Run Task`, select `Start VehicleApp runtime` and `Continue without scanning the output`.

You should see the tasks `run-mosquitto`, `run-vehicledatabroker`, `run-seatservice` and `run-feedercan` being executed in the Visual Studio Code output panel.

More information about the tasks are available [here](/docs/run_runtime_services_locally.md).

## Debugging the Vehicle App

Now that the runtime services are all up and running, let's start a debug session for the Vehicle App as next step.

### Starting debug session

- Open the main python file `src/SeatAdjusterApp/seatadjuster.py` file and set a breakpoint in `line 68`
- Press <kbd>F5</kbd> to start the Vehicle App to start a debug session and see the log output on the `DEBUG CONSOLE`

In the next step you will use a mqtt message to trigger this breakpoint.

### Sending MQTT messages to Vehicle App

Let's send a message to your Vehicle App using the mqtt broker that is running in the background.

> Make sure that [runtime services](#starting-runtime-services) and [Vehicle App debug session](#start-and-debug-vehicle-app) are running.

- Open `VSMqtt` extension in Visual Studio Code and connect to `mosquitto (local)`
- Set `Subscribe Topic` = `seatadjuster/setPosition/response` and click subscribe.
- Set `Subscribe Topic` = `seatadjuster/currentPosition` and click subscribe.
- Set `Publish Topic` = `seatadjuster/setPosition/request`
- Set and publish a dummy payload:

  ```json
  { "position": 300, "requestId": "xyz" }
  ```

- Now your breakpoint in the Vehicle App gets hit and you can inspect everything in your debug session
- After resuming execution (<kbd>F5</kbd>), a response from your Vehicle App is published to the response topic
- You can see the response in the MQTT window.

## Trigger your Github Workflows

GitHub workflows are used to build the container image for the Vehicle App, run unit and integration tests, collect the test results and create a release documentation and publish the Vehicle App. A detailed description of the workflow you can find [here](https://github.com/eclipse-velocitas/velocitas-docs/blob/main/docs/vehicle_app_releases.md).

### Run GitHub Workflow

- Make modification to your file, e.g. remove the last empty line from `src/SeatAdjusterApp/seatadjuster.py`
- Commit you change
  ```bash
  git add .
  git commit -m "removed emtpy line"
  ```
- Push
  ```bash
  git push
  ```
- Open your git repository in your favorite browser
- Navigate to `Actions` and go to [CI Workflow](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.github/workflows/ci.yml)
- Check Workflow Output, it should look like this:
  ![](/assets/ci-workflow-success.png)

## Build you first release

Now that the `CI Workflow` was successful, you are ready to build your first release. Your goal is to build a ready-to-deploy container image.

### Release the Vehicle App to push it to the container registry

- Open the `Code` page of your repository on GitHub.com and click on `Create a new release` in the Releases section on the right side
- Enter a version, e.g. v1.0.0, and click on `Publish release`
  GitHub will automatically create a tag using the version number
- The release workflow will be triggered
  - Open `Actions` on the repoitory and see the result

## Next steps
- Tutorial: [Creating a Python Vehicle Model](/docs/tutorials/tutorial_how_to_create_a_vehicle_model.md)
- Tutorial: [Create a Python Vehicle App](/docs/tutorials/tutorial_how_to_create_a_vehicle_app.md)
- Tutorial: [Develop and run integration tests for a Vehicle App](/docs/tutorials/integration_tests.md)
- Concept: [Development Model](/docs/concepts/development-model.md)