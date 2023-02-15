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

Using packages is pretty straight forward.

Velocitas already provides versioned packages for our main components of the development environment.

| name | type | description |
|:--------:|:--------:|:---------------:|
|[devenv-runtime-local](https://github.com/eclipse-velocitas/devenv-runtime-local)|`runtime`| Containing scripts and configuration for [Local Runtime Services](/docs/tutorials/vehicle-app-runtime/run_runtime_services_locally/)|
|[devenv-runtime-k3d](https://github.com/eclipse-velocitas/devenv-runtime-k3d)|`runtime`| Containing scripts and configuration for [Kubernetes Runtime Services](/docs/tutorials/vehicle-app-runtime/run_runtime_services_kubernetes/)|
|[devenv-devcontainer-setup](https://github.com/eclipse-velocitas/devenv-devcontainer-setup)|`setup`| Containing all devcontainer related settings used by velocitas repositories |
|[devenv-github-workflows](https://github.com/eclipse-velocitas/devenv-github-workflows)|`setup`| Containing github workflow files used by velocitas repositories |
|[devenv-github-templates](https://github.com/eclipse-velocitas/devenv-github-templates)|`setup`| Containing github templates used by velocitas repositories |

</br>

You can also use the [Python template repository](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) as a reference

## Installation

The [Velocitas CLI](https://github.com/eclipse-velocitas/cli) - acting as a package manager for _Vehicle App_ repositories - is installed inside our [devcontainer-base-images](https://github.com/eclipse-velocitas/devcontainer-base-images).
</br>
After creation of a devcontainer a [postCreateCommand](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.devcontainer/scripts/postCreateCommand.sh#L18) is configured to be executed which for the first time runs `velocitas init` and `velocitas sync`

## Usage

- Purpose of `velocitas init`:

  Checks content of `.velocitas.json` and downloads configured packages to `~/.velocitas/packages/<package_name>`

- Purpose of `velocitas sync`:

  Checks content of `~/.velocitas/packages/<package_name>` and synchronizes files inside the Vehicle App repository

- Purpose of `velocitas upgrade`:

  Compares versions installed/configured inside `.velocitas.json` with latest version of respective package repository

- Purpose of `velocitas package`:

  Lists installed packages and scripts inside of `~/.velocitas/packages`

- Purpose of `velocitas exec`:

  Executes programs of a component found inside of specific package `~/.velocitas/packages/<package_name>`

## Next steps

- Tutorials: [Development of Packages](/docs/lifecycle_management/packages/development/)
- Tutorials: [Velocitas CLI](/docs/lifecycle_management/cli/)
