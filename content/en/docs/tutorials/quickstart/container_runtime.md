---
title: "Install a working container runtime"
date: 2022-08-19T17:46:21+05:30
weight: 2
description: >
  Overview about the setup of tested container runtimes
---

In the past the recommended runtime would for sure be [Docker Desktop](https://www.docker.com/products/docker-desktop). But since Docker Inc. changed their license model it is fair enough for an open source project to look for free alternatives.

# macOS

Since the Docker Engine is not working out of the box on macOS, a virtualisation tool which helps emulating linux is needed. Fortunately there are several solutions on the market. Good results could be achieved using [Colima](https://github.com/abiosoft/colima).

## Setup Colima

For Colima to work properly you need Colima itself and a container client e.g. the Docker client, which is still free to use:

```bash
    brew install colima
    brew install docker
```

After the installation you need to start the runtime:

```bash
    colima start --cpu x --memory y
```

For M1 Macs it might be neccessary to add `--arch aarch64`

That's all you have to do. After these few steps you can go on with the devcontainer setup.
