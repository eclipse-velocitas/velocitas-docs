---
title: "Lifecycle Management"
date: 2023-02-13T09:43:25+05:30
weight: 7
description: >
  Overview of Velocitas Lifecycle Management.
---

## Introduction

Once a repository has been created from one of our _Vehicle App_ templates, the only way to receive updates into your derived repository is to manually pull in changes - This can be quite tedious and error prone. This is where our _Lifecycle Management_ comes to the rescue!

All of our main components of the development environment

* tools
* runtimes
* devcontainer configuration and setup
* build systems
* CI workflows
* ...

are (or will be) provided as versioned packages which can be updated individually, if required.

The driver for this is our [Velocitas CLI](https://github.com/eclipse-velocitas/cli) which is our package manager for _Vehicle App_ repositories.

## Project configuration

Every _Vehicle App_ repo comes with a `.velocitas.json` which is the project configuration of your app. It holds references to the packages and their respective versions you are using in your project.

Here is an example of this configuration:
```json
{
  "packages": [
    {
      "name": "devenv-devcontainer-setup",
      "version": "v1.0.0"
    },
        {
      "name": "devenv-runtime-local",
      "version": "v1.0.0"
    }
  ],
  "variables": {
    "foo": "bar",
    "baz": 2
  }
}
```

### Packages
Each package entry has the following fields:

| name | type | description |
|:--------|:--------|:---------------|
| name | string | can either be a fully qualified https URL to a git repository e.g. `https://my-organization/repos/my-velocitas-package.git` or a short name e.g. `devenv-devcontainer-setup` which would then be resolved to `https://github.com/eclipse-velocitas/<name>`|
| version | string | A git reference. May either be a tag, branch name or SHA. If it is a tag and your remote repository has valid semver tags, the CLI will suggest newer versions when running `velocitas upgrade`|
| variables | list | A list of variables to configure for this package. More details can be found below.

### Variables
Each variable declared at the root of your project configuration applies to all packages and their components.

Each variable is a key-value pair which maps the variable to a particular value. In the example above, the variable named `foo` is mapped to the string value `"bar"` whereas the variable named `baz` is mapped to the numeric value `5`.

## Concept

Placeholder

## Architecture

Placeholder

**Overview:** Placeholder
