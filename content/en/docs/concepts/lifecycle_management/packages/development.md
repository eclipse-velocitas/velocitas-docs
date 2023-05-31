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

If you plan to develop a _Package_ with the purpose of managing the runtime used together with your _Vehicle App_ the package needs a `runtime.json` at their root. The `runtime.json` is the runtime configuration containing all information for the relevant service dependencies with the following three required attributes:

 define and all configurations in form of Key/Value pair with specific pre–defined keys and corresponding values

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
            "value": "<path>"
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

## Next steps

* Lifecycle Management: [Velocitas CLI](/docs/concepts/lifecycle_management/velocitas-cli/)
