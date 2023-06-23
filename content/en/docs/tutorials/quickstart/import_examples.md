---
title: "Import examples"
date: 2022-08-30T14:56:21+05:30
weight: 2
description: >
  Learn how to import examples provided by the _Vehicle App_ SDK.
---

This guide will help you to import examples provided by the [SDK](https://github.com/eclipse-velocitas/vehicle-app-python-sdk/tree/main/examples/seat-adjuster) package into your template repository.

A Visual Studio Code task called `Import example app from SDK` is available in the `/.vscode/tasks.json` which can replace your `/app` directory in your template repository with some example _Vehicle Apps_ from the [SDK](https://github.com/eclipse-velocitas/vehicle-app-python-sdk/tree/main/examples) package.

{{% alert color="warning" %}}
To avoid overwriting existing changes in your `/app` directory, commit or stash changes before importing the example app.
{{% /alert %}}

1. Press <kbd>F1</kbd>
2. Select command `Tasks: Run Task`
3. Select `Import example app from SDK`
4. Choose `Continue without scanning the output`
5. Select `seat-adjuster`

## Run the _Vehicle App_ from SDK example

The launch settings are already prepared for the `VehicleApp` in the template repository `/.vscode/launch.json`. The configuration is meant to be as generic as possible to make it possible to run all provided example apps.

Every example app comes with its own `/app/AppManifest.json` to see which _Vehicle Services_ are configured and needed as a dependency.

To start the app:
Just press <kbd>F5</kbd> to start a debug session of the example _Vehicle App_.

To debug example, please check [How to debug _Vehicle App_?](/docs/tutorials/quickstart/quickstart/#how-to-debug-your-_vehicle-app_)
