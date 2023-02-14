---
title: "Packages"
date: 2023-02-13T09:43:25+05:30
weight: 1
aliases:
  - /docs/tutorials/packages.md
---

- [devenv-runtime-local](https://github.com/eclipse-velocitas/devenv-runtime-local)
- [devenv-runtime-k3d](https://github.com/eclipse-velocitas/devenv-runtime-k3d)
- [devenv-devcontainer-setup](https://github.com/eclipse-velocitas/devenv-devcontainer-setup)
- [devenv-github-workflows](https://github.com/eclipse-velocitas/devenv-github-workflows)
- [devenv-github-templates](https://github.com/eclipse-velocitas/devenv-github-templates)
- ( [devcontainer-base-images](https://github.com/eclipse-velocitas/devcontainer-base-images) )

## Configuration of Packages

We introduced a so called `manifest.json` which is placed at the root of the "devenv-*" package repository.

- [runtime manifest](https://github.com/eclipse-velocitas/devenv-runtime-local/blob/main/manifest.json)
- [setup manifest](https://github.com/eclipse-velocitas/devenv-devcontainer-setup/blob/main/manifest.json)

We divided the packages to hold components with a type of either `runtime` or `setup`.

{{< details "Runtime Manifest example" >}}

```json
{
    "components": [
        {
            "id": "runtime-local",
            "alias": "local",
            "type": "runtime",
            "programs": [
                {
                    "id": "ensure-dapr",
                    "executable": "./src/ensure-dapr.sh"
                },
                {
                    "id": "run-mosquitto",
                    "executable": "./src/run-mosquitto.sh"
                },
                {
                    "id": "run-vehicledatabroker",
                    "executable": "./src/run-vehicledatabroker.sh"
                },
                {
                    "id": "run-vehicledatabroker-cli",
                    "executable": "./src/run-vehicledatabroker-cli.sh"
                },
                {
                    "id": "run-feedercan",
                    "executable": "./src/run-feedercan.sh"
                },
                {
                    "id": "run-vehicleservices",
                    "executable": "./src/run-vehicleservices.sh"
                }
            ],
            "start": [
                {
                    "id": "ensure-dapr"
                },
                {
                    "id": "run-mosquitto",
                    "dependsOn": "ensure-dapr",
                    "startupLine": "mosquitto version 2.0.14 running"
                },
                {
                    "id": "run-vehicledatabroker",
                    "dependsOn": "run-mosquitto",
                    "startupLine": "You're up and running! Dapr logs will appear here."
                },
                {
                    "id": "run-feedercan",
                    "dependsOn": "run-vehicledatabroker"
                },
                {
                    "id": "run-vehicleservices",
                    "dependsOn": "run-vehicledatabroker"
                }
            ]
        }
    ]
}
```

{{< /details >}}

{{< details "Setup Manifest example" >}}

```json
{
    "components": [
        {
            "id": "devcontainer-setup",
            "type": "setup",
            "files": [
                {
                    "src": "setup/src/common",
                    "dst": ".devcontainer"
                },
                {
                    "src": "setup/src/${{ language }}/common",
                    "dst": ".devcontainer"
                },
                {
                    "src": "setup/src/${{ language }}/${{ repoType }}",
                    "dst": ".devcontainer"
                }
            ],
            "variables": [
                {
                    "name": "language",
                    "type": "string",
                    "required": true,
                    "description": "The programming language of the project. Either 'python' or 'cpp'"
                },
                {
                    "name": "repoType",
                    "type": "string",
                    "required": true,
                    "description": "The type of the repository: 'app' or 'sdk'"
                },
                {
                    "name": "appManifestPath",
                    "type": "string",
                    "required": true,
                    "description": "Path of the AppManifest file, relative to the .velocitas.json"
                }
            ]
        },
        {
            "id": "model-generator",
            "type": "setup",
            "onPostInit": [
                {
                    "id": "install-deps"
                },
                {
                    "id": "download-vspec"
                },
                {
                    "id": "generate-model"
                }
            ],
            "programs": [
                {
                    "id": "install-deps",
                    "executable": "python",
                    "args": ["./model-generator/install_deps.py"]
                },
                {
                    "id": "download-vspec",
                    "executable": "python",
                    "args": ["./model-generator/download_vspec.py"]
                },
                {
                    "id": "generate-model",
                    "executable": "python",
                    "args": ["./model-generator/generate_model.py"]
                }
            ]
        }
    ]
}
```

{{< /details >}}

### Explanation for manifest.json fields

{{< details "General" >}}

- id
- alias
- type

{{< /details >}}

{{< details "Runtime components" >}}

- programs
  - id
  - executable
- start
  - id
  - dependsOn
  - startupLine

{{< /details >}}

{{< details "Setup components" >}}

- files
  - src
  - dst
- variables
  - name
  - type
  - required
  - description
- onPostInit
  - id
- programs
  - id
  - executable
  - args

{{< /details >}}

<br/>
The package repositories can hold configuration files which can be synced (for setup components) inside a velocitas repository, or scripts which will be executed by the velocitas CLI.
<br/>

Packages will be downloaded by default to `/home/user/.velocitas/packages/<package_name>` folder inside the home directory.
<br/>

## Configuration of Vehicle Apps

For Vehicle App repositories we introduced the [.velocitas.json](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json)

{{< details ".velocitas.json example" >}}

```json
{
    "packages": [
        {
            "name": "devenv-runtime-local",
            "version": "v1.0.2"
        },
        {
            "name": "devenv-runtime-k3d",
            "version": "v1.0.0"
        },
        {
            "name": "devenv-github-workflows",
            "version": "v1.0.6"
        },
        {
            "name": "devenv-github-templates",
            "version": "v1.0.0"
        },
        {
            "name": "devenv-devcontainer-setup",
            "version": "v1.0.4"
        }
    ],
    "variables": {
        "language": "python",
        "repoType": "app",
        "appManifestPath": "app/AppManifest.json",
        "githubRepoId": "eclipse-velocitas/vehicle-app-python-template"
    }
}
```

{{< /details >}}

### Explanation for .velocitas.json fields

The `.velocitas.json` holds information which packages should be used on which version inside the Vehicle App repository.

- packages
  - name
  - version
- variables
  - <variable_exposed_by_component>
