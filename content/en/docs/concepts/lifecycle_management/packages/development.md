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

Create a repo at `https://my-organization/repos/my-velocitas-package.git` (e.g., `https://github.com/my-organisation/my-velocitas-package`).

## Configuration of Packages

Every _Package_ repository needs a `manifest.json` at their root. The `manifest.json` is the package configuration and holds package relevant information and its behaviour.

Here are examples of this configuration:

* [devenv-runtime-local manifest](https://github.com/eclipse-velocitas/devenv-runtime-local/blob/main/manifest.json)
* [devenv-devcontainer-setup manifest](https://github.com/eclipse-velocitas/devenv-devcontainer-setup/blob/main/manifest.json)

The manifest of a package describes a list of components. They are a collection of programs or files that serve a similar purpose or are inheritly connected. I.e. they provide a single runtime, a deployment for a runtime or add configuration required for Github Workflows or the devcontainer.
<br/>

More detailed information and explanation about configuration fields of the `manifest.json` and package development can be found [here](https://github.com/eclipse-velocitas/cli/blob/main/docs/features/PACKAGES.md).

## Next steps

* Lifecycle Management: [Velocitas CLI](/docs/concepts/lifecycle_management/cli/)
