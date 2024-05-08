---
title: "Project Configuration"
date: 2023-02-13T09:43:25+05:30
weight: 10
description: >
  Learn everything about Velocitas project configuration.
aliases:
  - /docs/concepts/lifecycle_management/project_configuration.md
---

Every _Vehicle App_ repo comes with a [`.velocitas.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) which is the project configuration of your app. It holds references to the packages and their respective versions as well as components you are using in your project.

Here is an example of this configuration:

```json
{
    "packages": {
        "devenv-runtimes": "v3.1.0",
        "devenv-devcontainer-setup": "v2.1.0"
    },
    "components": [
        "runtime-local",
        "devcontainer-setup",
        "vehicle-signal-interface",
        "sdk-installer",
        "grpc-interface-support"
    ],
    "variables": {
        "language": "python",
        "repoType": "app",
        "appManifestPath": "app/AppManifest.json",
        "githubRepoId": "eclipse-velocitas/vehicle-app-python-template",
        "generatedModelPath": "./gen/vehicle_model"
    },
    "cliVersion": "v0.9.0"
}
```

More detailed information and explanation about the project configuration and fields of the `.velocitas.json` can be found [here](https://github.com/eclipse-velocitas/cli/blob/main/docs/PROJECT-CONFIG.md).

## Next steps

* Lifecycle Management: [Usage of Packages](/docs/concepts/lifecycle_management/packages/usage/)
* Lifecycle Management: [Development of Packages](/docs/concepts/lifecycle_management/packages/development/)
