---
title: "Usage"
date: 2022-05-09T13:43:25+05:30
weight: 1
description: >
  Learn how to use velocitas packages.
aliases:
  - /docs/concepts/lifecycle_management/packages/usage.md
  - /docs/concepts/lifecycle_management/packages/usage
---

## Overview

After you have set up the `.velocitas.json` for your [project configuration](/docs/concepts/lifecycle_management/project-configuration.md), using packages is pretty straight forward.

Currently, the packages provided by the _Velocitas_ team are the following:
{{<table "table table-bordered">}}
| name | description |
|:--------|:---------------|
|[devenv-runtime-local](https://github.com/eclipse-velocitas/devenv-runtime-local)| Containing scripts and configuration for [Local Runtime Services](/docs/tutorials/vehicle-app-runtime/run_runtime_services_locally/)|
|[devenv-runtime-k3d](https://github.com/eclipse-velocitas/devenv-runtime-k3d)| Containing scripts and configuration for [Kubernetes Runtime Services](/docs/tutorials/vehicle-app-runtime/run_runtime_services_kubernetes/)|
|[devenv-devcontainer-setup](https://github.com/eclipse-velocitas/devenv-devcontainer-setup)| Basic configuration for the devcontainer, like proxy configuration, post create scripts, entry points for the lifecycle management. |
|[devenv-github-workflows](https://github.com/eclipse-velocitas/devenv-github-workflows)| Containing github workflow files used by velocitas repositories |
|[devenv-github-templates](https://github.com/eclipse-velocitas/devenv-github-templates)| Containing github templates used by velocitas repositories |
{{</table>}}
</br>

To see how these provided packages are used inside a `.velocitas.json` you can use the [python template repository](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) as a reference.

## Installation

The [Velocitas CLI](https://github.com/eclipse-velocitas/cli) - acting as a package manager for _Vehicle App_ repositories - is installed inside our [devcontainer-base-images](https://github.com/eclipse-velocitas/devcontainer-base-images).
</br>
After creation of a devcontainer a [postCreateCommand](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.devcontainer/scripts/postCreateCommand.sh#L18) is configured to be executed which runs:

* `velocitas init` which will initialize all packages referenced in your `.velocitas.json`. That means, it will download them and run their respective [onPostInit](https://github.com/eclipse-velocitas/cli/blob/main/docs/features/PACKAGES.md#onpostinit---arrayexecspec) programs, if any. (e.g, [automated model generation](/docs/tutorials/vehicle_model_creation/automated_model_lifecycle/))
* `velocitas sync` to sync files provided by some packages.

Check the section about our [Velocitas CLI](/docs/concepts/lifecycle_management/velocitas-cli/) to learn more about the background and usage of it.

## Velocitas Home Directory

The packages will be downloaded by the [Velocitas CLI](/docs/concepts/lifecycle_management/velocitas-cli/) to `~/.velocitas/packages/<package_name>`. More Information: [VELOCITAS_HOME](https://github.com/eclipse-velocitas/cli/blob/main/README.md#changing-default-velocitas_home-directory).

## Next steps

* Lifecycle Management: [Development of Packages](/docs/concepts/lifecycle_management/packages/development/)
* Lifecycle Management: [Velocitas CLI](/docs/concepts/lifecycle_management/velocitas-cli/)
