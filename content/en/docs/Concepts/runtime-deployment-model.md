---
title: "Runtime and Deployment Model"
date: 2022-05-09T13:43:25+05:30
weight: 4
aliases:
  - /docs/velocitas/docs/runtime-deployment-model.md
description: >
  Learn more about our deployment model and guiding principles.
---

The Velocitas project uses a common deployment model. It uses OCI-compliant containers to increase the flexibility for the support of different programming languages and runtimes, which accelerates innovation and development. OCI-compliant containers also allow for a standardized yet flexible deployment process, which increases the ease of operation. Using OCI-compliant is portable to different architectures as long as there is support for OCI-compliant containers on the desired platform (e.g., like a container runtime for arm32, arm64 or amd64).

## Guiding principles

The deployment model is guided by the following principles

- Applications are provided as OCI-compatible container images.
- The container runtime offers a Kubernetes-compatible control plane and API to manage the container lifecycle.
- Helm charts are used as deployment descriptor specification.

The template projects provided come with a preconfigured developer toolchain that accelerates the development process. The developer toolchain ensures an easy creation through a high-degree of automation, of all required artifacts which are needed to follow the Velocitas principles.

## Testing your container during development

The Velocitas project provides developers with a repository template and devcontainer that contains everything to build a containerized version of your app locally and test it. Check out our tutorial e.g., for python template (https://github.com/eclipse-velocitas/vehicle-app-python-template) to learn more.

## Automated container image builds

Velocitas uses GitHub workflows to automate the creation of your containerized application. A workflow is started with every increment of your application code that you push to your GitHub repository. The workflow creates a containerized version of your application and stores this container image in a registry. Further actions are carried out using this container (e.g., integration tests).

The workflows are set up to support multi-platform container creation and generate container images for amd64 and arm64 out of the box. This provides a great starting point for developers and lets you add additional support for further platforms easily.

Learn more about the concepts of the [Velocitas build and release workflows](/docs/velocitas/docs/vehicle_app_releases.md) and check out the example GitHub workflows in our repositories for python (https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.github/workflows/ci.yml).

## Next steps

- [Walkthrough: Deploy a Python Vehicle App with Helm](/docs/getting-started/tutorials/tutorial_how_to_deploy_a_vehicle_app_with_helm/)
