---
title: "Velocitas CLI"
weight: 20
date: 2023-02-13T09:43:25+05:30
description: >
  Learn everything about the Velocitas CLI.
aliases:
  - /docs/concepts/lifecycle_management/velocitas_cli
---

## Background

Our [Velocitas CLI](https://github.com/eclipse-velocitas/cli) is introduced to support the process of the lifecycle of a _Vehicle App_ as a project manager.

## Commands

You can find all information about available commands [here](https://github.com/eclipse-velocitas/cli/blob/main/README.md#commands).

### CLI Flow examples

### velocitas create

Create a new Velocitas Vehicle App project.
{{% alert title="Note" %}}
`velocitas create` needs to be executed inside our generic [vehicle-app-template](https://github.com/eclipse-velocitas/vehicle-app-template) (inside the devcontainer) where a so called [`package-index.json`](https://github.com/eclipse-velocitas/vehicle-app-template/blob/main/package-index.json) is located for now, which is a central place of defining our extension and core packages with their respective exposed interfaces.
{{% /alert %}}

```bash
vscode ➜ /workspaces/vehicle-app-template (main) $ velocitas create
Interactive project creation started
> What is the name of your project? MyApp
> Which programming language would you like to use for your project? (Use arrow keys)
❯ python
  cpp
> Would you like to use a provided example? No
> Which functional interfaces does your application have? (Press <space> to select, <a> to toggle all, <i> to invert selection, and <enter> to proceed)
❯◉ Vehicle Signal Interface based on VSS and KUKSA Databroker
 ◯ gRPC service contract based on a proto interface description
...
Config 'src' for interface 'vehicle-signal-interface': URI or path to VSS json (Leave empty for default: v3.0)
...
```

### velocitas init

Download packages configured in your `.velocitas.json` to [VELOCITAS_HOME](https://github.com/eclipse-velocitas/cli/blob/main/README.md#changing-default-velocitas_home-directory)

```bash
vscode ➜ /workspaces/vehicle-app-python-template (main) $ velocitas init
Initializing Velocitas packages ...
... Downloading package: 'devenv-runtimes:v1.0.1'
... Downloading package: 'devenv-github-workflows:v2.0.4'
... Downloading package: 'devenv-github-templates:v1.0.1'
... Downloading package: 'devenv-devcontainer-setup:v1.1.7'
Running post init hook for model-generator
Running 'install-deps'
...
```

### velocitas sync

If any package provides files they will be synchronized into your repository.
{{% alert title="Note" %}}
This will overwrite any changes you have made to the files manually! Affected files are prefixed with an auto generated notice:
{{% /alert %}}

```bash
vscode ➜ /workspaces/vehicle-app-python-template (main) $ velocitas sync
Syncing Velocitas components!
... syncing 'devenv-github-workflows'
... syncing 'devenv-github-templates'
... syncing 'devenv-devcontainer-setup'
```

### velocitas upgrade

Updates Velocitas components.

```bash
vscode ➜ /workspaces/vehicle-app-python-template (main) $ velocitas upgrade --dry-run
Checking for updates!
... 'devenv-runtimes' is up to date!
... 'devenv-github-workflows' is up to date!
... 'devenv-github-templates' is up to date!
... 'devenv-devcontainer-setup' is currently at v1.1.6, can be updated to v1.1.7
... Do you wish to continue? [y/n] [y]: y
```

### velocitas package

Prints information about packages.

```bash
vscode ➜ /workspaces/vehicle-app-python-template (main) $ velocitas package devenv-devcontainer-setup
devenv-devcontainer-setup
    version: v1.1.7
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
vscode ➜ /workspaces/vehicle-app-python-template (main) $ velocitas package devenv-devcontainer-setup -p
/home/vscode/.velocitas/packages/devenv-devcontainer-setup/v1.1.7
```

### velocitas exec

Executes a script contained in one of your installed components.

```bash
vscode ➜ /workspaces/vehicle-app-python-template (main) $ velocitas exec runtime-local run-vehicledatabroker
#######################################################
### Running Databroker                              ###
#######################################################
...
```

More detailed usage can be found at the [Velocitas CLI README](https://github.com/eclipse-velocitas/cli/blob/main/README.md).

## Additional Information

### Cache Usage

The Velocitas CLI supports caching data for a _Vehicle App_ project.
<br/>
The cache data makes it easy for any script/program of a component to read from or write to.
<br/>
More detailed information about the _Project Cache_ can be found [here](https://github.com/eclipse-velocitas/cli/blob/main/docs/features/PROJECT-CACHE.md).

### Built-In Variables

The Velocitas CLI also creates default environment variables which are available to every script/program.

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

* Lifecycle Management: [Troubleshooting](/docs/concepts/lifecycle_management/troubleshooting/)
