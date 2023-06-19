---
title: "Development"
date: 2022-05-09T13:43:25+05:30
weight: 2
description: >
  Learn how to develop an own package.
aliases:
  - /docs/concepts/lifecycle_management/packages/development.md
  - /docs/concepts/lifecycle_management/packages/development
---

## Getting started

First thing you need to do is to create a repository at e.g., `https://github.com/my-organisation/my-velocitas-package`. The URL needs to be referenced in the `.velocitas.json` of your _Vehicle App_ repository.

## General configuration of Packages

Every _Package_ repository needs a `manifest.json` at their root. The `manifest.json` is the package configuration and holds package relevant information and its behaviour.

Here are examples of this configuration:

* [devenv-runtimes manifest](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/manifest.json)
* [devenv-devcontainer-setup manifest](https://github.com/eclipse-velocitas/devenv-devcontainer-setup/blob/main/manifest.json)

The manifest of a package describes a list of components. They are a collection of programs or files that serve a similar purpose or are inheritly connected. I.e. they provide a single runtime, a deployment for a runtime or add configuration required for Github Workflows or the devcontainer.
<br/>

More detailed information and explanation about configuration fields of the `manifest.json` and package development can be found [here](https://github.com/eclipse-velocitas/cli/blob/main/docs/features/PACKAGES.md).

## Configuration of Runtime Packages

 If you want to add a new service, adapt [`runtime.json`](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/runtime.json) and [`manifest.json`](https://github.com/eclipse-velocitas/devenv-runtimes/blob/main/manifest.json). In order to use a newly created or updated service, new changes on [devenv-runtimes](https://github.com/eclipse-velocitas/devenv-runtimes/tree/main) need to be tagged and referenced inside [`.velocitas.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) of the respective package version via a tag or branch name of the repository. When a version is changed in your [`.velocitas.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) you have to initialize it through `velocitas init` from the terminal so the new package version will be installed. A new service can be started by using velocitas cli command `velocitas exec runtime-local <service_id> <args>` which can be also configured inside your `./.vscode/tasks.json`.

If you plan to develop a _Package_ with the purpose of managing the runtime used together with your _Vehicle App_ the package needs a `runtime.json` at their root. The `runtime.json` is the runtime configuration containing all information for the relevant service dependencies with the following three required attributes:

{{<table "table table-bordered">}}
|  Property  |                                           Description                                            |
|------------|--------------------------------------------------------------------------------------------------|
| id         | unique service id                                                                                |
| interfaces | used for dependency resolution between _Vehicle App_ and runtime                                   |
| config     | configurations in form of Key/Value pair with specific pre–defined keys and corresponding values |
{{</table>}}

## Supported config keys of a service

{{<table "table table-bordered">}}
| Key           | Value Description                                                      |
|---------------|------------------------------------------------------------------------|
| image         | URI of a container image                                               |
| port          | port number                                                            |
| port-forward  | port mapping for forwarding                                            |
| env           | environment variable used by the service: `<env_key>=<env_value>`      |
| mount         | path for mounting files: `<source_path>:<target_path>`                 |
| arg           | argument for starting the service                                      |
| start-pattern | optional start pattern for identifying if the service starts correctly |
{{</table>}}

### Runtime configuration helper

```json
{
    "id": "<service_id>",
    "interfaces": [
        "<interface>"
    ],
    "config": [
        {
            "key": "image",
            "value": "<image>:<tag>"
        },
        {
            "key": "port",
            "value": "<port_number>"
        },
        {
            "key": "port-forward",
            "value": "<source_port>:<target_port>"
        },
        {
            "key": "env",
            "value": "<env_key>=<env_value>"
        },
        {
            "key": "mount",
            "value": "<source_path>:<target_path>"
        },
        {
            "key": "arg",
            "value": "<arg>"
        },
        {
            "key": "start-pattern",
            "value": ".*Listening on \\d+\\.\\d+\\.\\d+\\.\\d+:\\d+"
        }
    ]
}
```

In order to use a newly created or updated service, changes on the respective _Package_ need to be tagged and referenced inside the [`.velocitas.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) of your _Vehicle App_ repository via a tag or branch name of the repository. More info about installation: [Usage](/docs/concepts/lifecycle_management/packages/usage/#installation).

{{% alert title="Note" %}}
A new service can be started manually and/or configured inside your `./.vscode/tasks.json` with:
</br> `velocitas exec runtime-local <service_id> <args>`
{{% /alert %}}


## Next steps

* Lifecycle Management: [Velocitas CLI](/docs/concepts/lifecycle_management/velocitas-cli/)
