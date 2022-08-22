---
title: "Working behind proxy"
date: 2022-08-19T17:46:21+05:30
weight: 2
description: >
  Learn how to setup your docker desktop and Visual Studio Code behind a coorperate proxy.
---

We know how time consuming it could be to setup your environment behind a cooperate proxy. This guide will help you to set it up correctly.

# Docker Desktop

First of all you need to install [Docker Desktop](https://www.docker.com/get-started/). 

{{% alert title="Right Version" %}}
As we recognized a proxy issue in Docker Desktop [#12672](https://github.com/docker/for-win/issues/12672) we strongly recomment to use a Docker Desktop version >= 4.8.2. In case you have an older version on your machine please update to the current version.
{{% /alert %}}

In the next step you need to configure your Docker user profile (`~/.docker/config.json`), see [Docker Documentation](https://docs.docker.com/network/proxy/) for more details.

```json
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "http://host.docker.internal:3128",
     "httpsProxy": "http://host.docker.internal:3128",
     "noProxy": "*.test.example.com,.example2.com,127.0.0.0/8"
   }
 }
}
```

## Environment Variables

It is required to set the following environment variables:

- `HTTP_PROXY` - Target proxy, e.g. `http://192.168.1.12:3128`
- `HTTPS_PROXY` - Target proxy, e.g. `http://192.168.1.12:3128`
- `DEVCONTAINER_PROXY` - Enables proxy configuration for the devContainer. Please use `.Proxy` as value and don't forget (dot) in the value


# Visual Studio Code

A template configuration using proxy settings is provided by our template repository with `.devcontainer/Dockerfile.Proxy`. By setting the environment variable `DEVCONTAINER_PROXY` to `.Proxy` the file
`.devcontainer/Dockerfile.Proxy` will be used instead of `.devcontainer/Dockerfile`.

{{% alert title="Troubleshooting" %}}
- If you are running in Linux and expierence issues with the internal docker host proxy, please set the   `DEVCONTAINER_PROXY_HOST` environment variable to the internal docker host.
- If you are trying to connect to a proxy which is running on a different port than `3128`, please use the `DEVCONTAINER_PROXY_Port` environment variable to define the port.

- If you experience issues during initial DevContainer build and you want to start over, then you want to make sure you clean all images and volumes in Docker Desktop, otherwise cache might be used. Use the Docker Desktop UI to remove all volumes and containers.

- Proxy settings in `~/.docker/config.json` will override settings in `.devcontainer/Dockerfile.Proxy`, which can cause problems.
In case the DevContainer is still not working, check if proxy settings are set correctly in the Docker user profile (`~/.docker/config.json`), see [Docker Documentation](https://docs.docker.com/network/proxy/) for more details.
Verify that the `noProxy` setting in `~/.docker/config.json` (if existing) is compatible with the setting of `NO_PROXY` in `.devcontainer/Dockerfile.Proxy`.
The development environment relies on communication to localhost (e.g. localhost, 127.0.0.1) and it is important that the proxy setting is correct so that connections to localhost are not forwarded to the proxy.

{{% /alert %}}