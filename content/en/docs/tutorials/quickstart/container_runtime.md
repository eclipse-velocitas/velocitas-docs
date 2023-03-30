---
title: "Install a working container runtime"
date: 2022-08-19T17:46:21+05:30
weight: 2
description: >
  Overview about the setup of tested container runtimes
---

In the past the recommended runtime would for sure be [Docker Desktop](https://www.docker.com/products/docker-desktop). But since Docker Inc. changed their license model it is fair enough for an open source project to look for free alternatives.

## Linux

The obvious (and our recommended) "alternative" to Docker Desktop on Linux is to just use the [Docker Engine](https://docs.docker.com/engine/) (without Docker Desktop), a pure CLI-based solution available for most popular Linux distributions licensed under the Apache License, version 2.0. Installation instructions can be found [here](https://docs.docker.com/engine/install/).

## macOS

Since the Docker Engine is not working out of the box on macOS, a virtualisation tool which helps emulating linux is needed. Fortunately there are several solutions on the market. Good results could be achieved using [Colima](https://github.com/abiosoft/colima).

### Setup Colima

*Please uninstall or at least quit Docker Desktop if you already used it, before starting the setup.*

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

Docker Desktop uses 5 cores and 12 GB of RAM by default on an M1 MacBook Pro. The equivalent in Colima can be achieved with

```bash
    colima start --cpu 5 --memory 12
```

That's all you have to do. After these few steps you can go on with the devcontainer setup.

#### Drawbacks

The only drawback noticed so far is, that K9S is not working properly on M1 Macs. Since the container runtime and deployment are working also without K9S, this is just a minor issue. Nevertheless, the team is working on a solution.

## Microsoft Windows

There is currently no recommended alternative for Windows except using GitHub codespaces, a cloud-based development environment.

An option would be to setup a VM (e.g. with VirtualBox or VMWare) running a Linux system with Docker Engine (see above).

## Other alternatives

Besides our recommendations above, there are further alternatives, which are not yet evaluated by this project or have some other drawbacks, blocking a recommendation. 

For example, you could try [Podman](https://podman.io/)/[Buildah](https://buildah.io/), which can replace `docker run` and `docker build`, respectively.
Podman is available for MacOS, Windows, and several Linux distributions.
Buildah seems just being available for several Linux distributions.
