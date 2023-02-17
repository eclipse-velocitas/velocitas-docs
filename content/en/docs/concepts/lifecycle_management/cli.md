---
title: "CLI"
weight: 3
date: 2023-02-13T09:43:25+05:30
description: >
  Learn everything about the Velocitas CLI.
aliases:
  - /docs/concepts/lifecycle_management/cli.md
  - /docs/concepts/lifecycle_management/cli
---

## Background

Our [Velocitas CLI](https://github.com/eclipse-velocitas/cli) is introduced to support the process of the lifecycle of a _Vehicle App_ as a package manager.
It is written in TypeScript and based on the open CLI framework [oclif](https://oclif.io/).

## Basic Usage

{{<table "table table-bordered">}}
| command | purpose |
|:--------|:--------|
|[`velocitas init`](https://github.com/eclipse-velocitas/cli#velocitas-init)|Checks content of `.velocitas.json` and downloads configured packages to [`$VELOCITAS_HOME/.velocitas`](https://github.com/eclipse-velocitas/cli/blob/main/README.md#changing-default-velocitas_home-directory).|
|[`velocitas sync`](https://github.com/eclipse-velocitas/cli#velocitas-sync)|Checks content of `$VELOCITAS_HOME/.velocitas/packages/<package_name>` and synchronizes files inside the _Vehicle App_ repository.|
|[`velocitas upgrade`](https://github.com/eclipse-velocitas/cli#velocitas-upgrade)|Compares installed/configured versions inside `.velocitas.json` with latest version of respective package repository.|
|[`velocitas package`](https://github.com/eclipse-velocitas/cli#velocitas-package-name)|Lists installed packages and scripts inside of `$VELOCITAS_HOME/.velocitas/packages`.|
|[`velocitas exec`](https://github.com/eclipse-velocitas/cli#velocitas-exec-component-id-args)|Executes programs of a component found inside of specific package `$VELOCITAS_HOME/.velocitas/packages/<package_name>`.|
{{</table>}}

### CLI Flow examples

#### velocitas init

```bash
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ velocitas init
Initializing Velocitas packages ...
... Downloading package: 'devenv-runtime-local:v1.0.2'
... Downloading package: 'devenv-runtime-k3d:v1.0.0'
... Downloading package: 'devenv-github-workflows:v1.0.6'
... Downloading package: 'devenv-github-templates:v1.0.0'
... Downloading package: 'devenv-devcontainer-setup:v1.0.5'
Running post init hook for model-generator
Running 'install-deps'
...
```

### velocitas sync

```bash
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ velocitas sync
Syncing Velocitas components!
... syncing 'devenv-github-workflows'
... syncing 'devenv-github-templates'
... syncing 'devenv-devcontainer-setup'
```

### velocitas upgrade

```bash
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ velocitas upgrade --dry-run
Checking for updates!
... 'devenv-runtime-local' is up to date!
... 'devenv-runtime-k3d' is up to date!
... 'devenv-github-workflows' is up to date!
... 'devenv-github-templates' is up to date!
... 'devenv-devcontainer-setup' is currently at v1.0.4, can be updated to v1.0.5
... Do you wish to continue? [y/n] [y]: y
```

### velocitas package

```bash
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ velocitas package devenv-devcontainer-setup
devenv-devcontainer-setup
    version: v1.0.4
    components:
      - id: devcontainer-setup
        type: setup
        variables:
            language
                type: string
                description: The programming language of the project. Either 'python' or 'cpp'
                required: true
            repoType
                type: string
                description: The type of the repository: 'app' or 'sdk'
                required: true
            appManifestPath
                type: string
                description: Path of the AppManifest file, relative to the .velocitas.json
                required: true
```

```bash
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ velocitas package devenv-devcontainer-setup -p
/home/vscode/.velocitas/packages/devenv-devcontainer-setup/v1.0.4
```

### velocitas exec

```bash
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ ./velocitas-cli/bin/dev exec runtime-local run-vehicledatabroker
#######################################################
### Running Databroker                              ###
#######################################################
...
```

More detailed usage can be found at the [CLI README](https://github.com/eclipse-velocitas/cli/blob/main/README.md).

## Additional Information

### Cache Usage

The CLI supports caching data for a _Vehicle App_ project.
<br/>
The cache data makes it easy for any script/program of a component to read from or write to.
<br/>
More detailed information about the _Project Cache_ can be found [here](https://github.com/eclipse-velocitas/cli/blob/main/docs/features/PROJECT-CACHE.md).

### Built-In Variables

The CLI creates default environment variables which are available to every script/program.

{{<table "table table-bordered">}}
| variable | description |
|:--------|:--------|
|`VELOCITAS_WORKSPACE_DIR`| Current working directory of the _Vehicle App_ |
|`VELOCITAS_CACHE_DIR`| _Vehicle App_ project specific cache directory. e.g, `~/.velocitas/cache/<generatedMd5Hash>` |
|`VELOCITAS_CACHE_DATA`| JSON string of `~/.velocitas/cache/<generatedMd5Hash>/cache.json` |
|`VELOCITAS_APP_MANIFEST`| JSON string of the _Vehicle App_ AppManifest |
{{</table>}}

More detailed information about _Built-In Variables_ can be found [here](https://github.com/eclipse-velocitas/cli/blob/main/docs/features/VARIABLES.md).

## Next steps

* Lifecycle Management: [Troubleshoot](/docs/concepts/lifecycle_management/troubleshooting/)
