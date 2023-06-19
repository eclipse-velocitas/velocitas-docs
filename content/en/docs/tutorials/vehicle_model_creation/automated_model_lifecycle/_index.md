---
title: "Automated Vehicle Model Lifecycle"
date: 2023-03-08T15:00:00+01:00
weight: 10
description: >
  Learn how to refer a model source and how the automated model lifecycle is working.
---

{{% alert title="Info" %}} This article describes our new model lifecycle approach released on Friday, 2023-03-03. With that, the model is now automatically generated with the instantiation of the devContainer. It is generated from the vehicle model source file referenced in the AppManifest.

For the time being, the integration of services is not supported by the new approach.

The previous approach, using pre-generated model repositories, is now deprecated. But it is still available and [described here](../manual_model_creation).{{% /alert %}}

This tutorial will show you how:

- the vehicle API used as the source to generate the model is referenced in the app manifest,
- the automatic generation of the model works,
- you can trigger manual recreation of the model (after adding extensions to the API required by your project)

## How to Reference a Model Specification

The model specification defines the vehicle API to be used by your project. It is referenced in the `AppManifest.json` via a URI or local file path like this:

{{< tabpane lang=json >}}
{{< tab "URI reference" >}}
"vehicleModel": {
    "src": "<https://github.com/COVESA/vehicle_signal_specification/releases/download/v3.0/vss_rel_3.0.json>"
}
{{< /tab >}}
{{< tab "Local file reference" >}}
"vehicleModel": {
    "src": "./my_model/my_model.json"
}
{{< /tab >}}
{{< /tabpane >}}

{{% alert title="Info" %}} The reference must point to a JSON file containing the model specification as VSS vspec. References to a VSS `.vspec` file hierarchy are not supported as of now.
{{% /alert %}}

## Model Creation

The generation of the model is taking place:

- through a [onPostInit hook](/docs/concepts/lifecycle_management/packages/usage/#installation) when `velocitas init` is called:
  - either triggered manually or
  - automatically during the instantiation of the devContainer through our [Velocitas Lifecycle Management](/docs/concepts/lifecycle_management), or
- when you trigger the VS Code task `(Re-)generate vehicle model` explicitly.

The model generation is a three step process:

1. The model generator is installed as a Python package (if not already present)
2. The referenced model specification is downloaded (if no local reference)
3. The model code is generated and installed.

![Model lifecycle overview](./model_lifecycle.drawio.svg)

The model is generated using our [Velocitas vehicle-model-generator](https://github.com/eclipse-velocitas/vehicle-model-generator).
The used version and also the repository of the generator can be altered via the `variables` section of the project configuration in the `.velocitas.json`.
The default values for those are defined in the [`manifest.json`](https://github.com/eclipse-velocitas/devenv-devcontainer-setup/blob/main/manifest.json) of the [devContainer setup package](https://github.com/eclipse-velocitas/devenv-devcontainer-setup).
Also, the target folder for the generated model source code is specified here:

```json
{
    "variables": {
        "modelGeneratorGitRepo": "https://github.com/eclipse-velocitas/vehicle-model-generator.git",
        "modelGeneratorGitRef": "v0.3.0",
        "generatedModelPath": "./gen/vehicle_model"
    }
}
```

In Python template based projects the generated model is finally installed in the site-packages folder, while in C++ projects it is made available as a CMake include folder.

## Further information

- Concept: [SDK Overview](/docs/concepts/vehicle_app_sdk_overview.md)
- Tutorial: [Setup and Explore Development Environment](/docs/tutorials/quickstart)
- Tutorial: [Create a _Vehicle App_](/docs/tutorials/vehicle-app-development)
