---
title: "Development"
date: 2022-05-09T13:43:25+05:30
weight: 2
description: >
  Learn how to develop an own package.
aliases:
  - /docs/lifecycle_management/packages/development.md
  - /docs/lifecycle_management/packages/development
---

## Configuration of Packages

Every _Package_ repo comes with a `manifest.json` which is the package configuration. It holds package relevant information and its behaviour.

Here are examples of this configuration:

- [runtime manifest](https://github.com/eclipse-velocitas/devenv-runtime-local/blob/main/manifest.json)
- [setup manifest](https://github.com/eclipse-velocitas/devenv-devcontainer-setup/blob/main/manifest.json)

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
            ],
            "programs": [
                {
                    "id": "install-deps",
                    "executable": "python",
                    "args": ["./model-generator/install_deps.py"]
                },
            ]
        }
    ]
}
```

{{< /details >}}

</br>

We divided the packages to hold components with a type of either `runtime` or `setup`.

### Components

Each component entry of a package has the following fields:

| name | type | description | componentType |
|:--------:|:--------:|:---------------:|:---------------:|
| id | string | Unique ID of component inside a package |general|
| alias | string | Additional shortname, can be used in the CLI |general|
| type | string | Either `runtime` or `setup`|general|
| variables | variable[] | Holds description of exposed variable needed by the component|general|
| programs | program[] | List of programs to be known by a component|general|
| start | start[] | Preconfigured list of start scripts & order|`runtime`|
| files | file[] | Preconfigured list of start scripts & order|`setup`|
| onPostInit | list | List of objects containing an id referencing a program to run after `velocitas init`|`setup`|

#### Types

##### variable

| name | type | description | componentType |
|:--------:|:--------:|:---------------:|:---------------:|
| name | string | Name of variable used in `.velocitas.json` of the _Vehicle App_ |general|
| type | string | Datatype of exposed variable |general|
| required | boolean | Defines if variable is essential to run the component|general|
| description | string | Description of purpose of variable |general|

##### program

| name | type | description | componentType |
|:--------:|:--------:|:---------------:|:---------------:|
| id | string | Unique ID of components program |general|
| executable | string | Path to an executable script or type of script inside the package repository |general|
| args | string | Additional arguments/Path to script |general|

##### start

| name | type | description | componentType | optional |
|:--------:|:--------:|:---------------:|:---------------:|:---------------:|
| id | string | Reference to a program ID |`runtime`||
| dependsOn | string | Dependant program can be defined|`runtime`|x|
| startupLine | string | When line is reached, start of the program is ensured|`runtime`|x|

##### file

| name | type | description | componentType |
|:--------:|:--------:|:---------------:|:---------------:|
| src | string | Path to a folder inside _Package_ Repository containing files to sync |`setup`|
| dst | string | Destination to sync files inside _Vehicle App_ Repository|`runtime`|

<br/>
The package repositories can hold configuration files which can be synced (for setup components) inside a velocitas repository, or scripts which will be executed by the velocitas CLI.
<br/>

Packages will be downloaded by default to `~/.velocitas/packages/<package_name>` folder inside the home directory.
<br/>

## Next steps

- Lifecycle Management: [Velocitas CLI](/docs/lifecycle_management/cli/)
