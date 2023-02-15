---
title: "Usage"
date: 2022-05-09T13:43:25+05:30
weight: 1
description: >
  Learn how to use velocitas packages.
aliases:
  - /docs/lifecycle_management/packages/usage.md
  - /docs/lifecycle_management/packages/usage
---

## Overview

After you have set up the `.velocitas.json` for your [project configuration](/docs/lifecycle_management/project-configuration.md), using packages is pretty straight forward.

Currently, the packages provided by the _Velocitas_ team are the following:

| name | type | description |
|:--------:|:--------:|:---------------:|
|[devenv-runtime-local](https://github.com/eclipse-velocitas/devenv-runtime-local)|`runtime`| Containing scripts and configuration for [Local Runtime Services](/docs/tutorials/vehicle-app-runtime/run_runtime_services_locally/)|
|[devenv-runtime-k3d](https://github.com/eclipse-velocitas/devenv-runtime-k3d)|`runtime`| Containing scripts and configuration for [Kubernetes Runtime Services](/docs/tutorials/vehicle-app-runtime/run_runtime_services_kubernetes/)|
|[devenv-devcontainer-setup](https://github.com/eclipse-velocitas/devenv-devcontainer-setup)|`setup`| Basic configuration for the devcontainer, like proxy configuration, post create scripts, entry points for the lifecycle management. |
|[devenv-github-workflows](https://github.com/eclipse-velocitas/devenv-github-workflows)|`setup`| Containing github workflow files used by velocitas repositories |
|[devenv-github-templates](https://github.com/eclipse-velocitas/devenv-github-templates)|`setup`| Containing github templates used by velocitas repositories |

</br>

To see how these provided packages are used you can use the [python template repository](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) as a reference.

## Installation

The [Velocitas CLI](https://github.com/eclipse-velocitas/cli) - acting as a package manager for _Vehicle App_ repositories - is installed inside our [devcontainer-base-images](https://github.com/eclipse-velocitas/devcontainer-base-images).
</br>
After creation of a devcontainer a [postCreateCommand](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.devcontainer/scripts/postCreateCommand.sh#L18) is configured to be executed which for the first time runs `velocitas init` and `velocitas sync`

Check the section about our [Velocitas CLI](https://github.com/eclipse-velocitas/cli) to learn more about the background and usage of it.

## Next steps

- Lifecycle Management: [Development of Packages](/docs/lifecycle_management/packages/development/)
- Lifecycle Management: [Velocitas CLI](/docs/lifecycle_management/cli/)
