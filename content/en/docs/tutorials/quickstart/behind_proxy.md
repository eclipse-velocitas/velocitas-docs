---
title: "Working behind proxy"
date: 2022-08-19T17:46:21+05:30
weight: 2
description: >
  Learn how to setup your docker desktop and Visual Studio Code behind a coorperate proxy.
---

We know how time consuming it could be to setup your environment behind a cooperate proxy. This guide will help you to set it up correctly.

# Docker Desktop

As we recognized a proxy issue in Docker Desktop [#12672](https://github.com/docker/for-win/issues/12672) we strongly recomment to use a Docker Desktop version >= 4.8.2.

To be able to use the DevContainer in Visual Studio Code behind a proxy, you have to make sure that your proxy configuration in Docker Desktop is correct. 

Go to `Settings` > `Resources` > `Proxies` and enable `Manual proxy configuration` and set HTTP and HTTPS to your host and port e.g. "http://localhost:3128", for more details read the Docker Desktop documentation: https://docs.docker.com/network/proxy/



# Environment Variables

It is required to set the following environment variables
- `HTTP_PROXY`
- `HTTPS_PROXY`
- `DEVCONTAINER_PROXY`
- `DEVCONTAINER_PROXY_HOST`
- `DEVCONTAINER_PROXY_PORT`

#### Windows

1. Edit environment variables for your account
2. Create HTTP and HTTPS PROXY environment variables 
   - `HTTP_PROXY`=`ProxyHostWithPortNumber`
   - `HTTPS_PROXY`=`ProxyHostWithPortNumber`
2. Create a new environment variables to enable proxy configuration for the devContainer (don't forget (dot) in the value):
   - `DEVCONTAINER_PROXY`=.Proxy
3. If you are using a different HOST or PORT than http://172.17.0.1:3128 for your Proxy, you have to set another environment variable as follows:
   - `DEVCONTAINER_PROXY_HOST`=`ProxyHost`
   - `DEVCONTAINER_PROXY_PORT`=`ProxyPortNumber`
4. Restart Visual Studio Code to pick up the new environment variable

#### macOS & Linux

```
echo "export DEVCONTAINER_PROXY=.Proxy" >> ~/.bash_profile
echo "export DEVCONTAINER_PROXY_HOST=<ProxyHost>" >> ~/.bash_profile
echo "export DEVCONTAINER_PROXY_PORT=<ProxyPortNumber>" >> ~/.bash_profile
source ~/.bash_profile
```


# Visual Studio Code

A template configuration using proxies exists in `.devcontainer/Dockerfile.Proxy` is provided by our template repository and by setting the environment variable `DEVCONTAINER_PROXY` to `.Proxy` the file
`.devcontainer/Dockerfile.Proxy` will be used instead of `.devcontainer/Dockerfile`.

The template configuration uses the following default configuration:

```
ENV HTTP_PROXY="http://172.17.0.1:${PROXY_PORT:-3128}"
```

- If your proxy is not available on `172.17.0.1` than you must modify `DEVCONTAINER_PROXY_HOST`.
- If your proxy does not use 3128 as port you can set another port in the environment variable `DEVCONTAINER_PROXY_PORT`



## Proxy troubleshooting

If you experience issues during initial DevContainer build and you want to start over, then you want to make sure you clean all images and volumes in Docker Desktop, otherwise cache might be used. Use the Docker Desktop UI to remove all volumes and containers.

Proxy settings in `~/.docker/config.json` will override settings in `.devcontainer/Dockerfile.Proxy`, which can cause problems.
In case the DevContainer is still not working, check if proxy settings are set correctly in the Docker user profile (`~/.docker/config.json`), see [Docker Documentation](https://docs.docker.com/network/proxy/) for more details.
Verify that the `noProxy` setting in `~/.docker/config.json` (if existing) is compatible with the setting of `NO_PROXY` in `.devcontainer/Dockerfile.Proxy`.
The development environment relies on communication to localhost (e.g. localhost, 127.0.0.1) and it is important that the proxy setting is correct so that connections to localhost are not forwarded to the proxy.
