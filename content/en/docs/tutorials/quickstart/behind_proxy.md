---
title: "Working behind proxy"
date: 2022-08-19T17:46:21+05:30
weight: 2
description: >
  Learn how to setup your docker desktop and Visual Studio Code behind a coorperate proxy.
---

We know how time consuming it could be to setup your environment behind a cooperate proxy. This guide will help you to set it up correctly.

# HTTP(s) proxy server

Install and configure the proxy server as recommented or required by your company. For example you could use [PX](https://github.com/genotrance/px), which is a HTTP(s) proxy server that allows applications to authenticate through an NTLM or Kerberos proxy server, typically used in corporate deployments, without having to deal with the actual handshake. Px leverages Windows SSPI or single sign-on and automatically authenticates using the currently logged in Windows user account. It is also possible to run Px on Windows, Linux and MacOS without single sign-on by configuring the domain, username and password to authenticate with. (Source: [PX](https://github.com/genotrance/px))

- Install your HTTP(s) proxy server
- Start your HTTP(s) proxy server

# Docker Desktop

You need to install [Docker Desktop](https://www.docker.com/get-started/) using the right version. 
As we recognized a proxy issue in Docker Desktop [#12672](https://github.com/docker/for-win/issues/12672) we strongly recomment to use a Docker Desktop version >= 4.8.2. In case you have an older version on your machine please update to the current version.

In the next step you need to enter your proxy settings:
- Open Docker Desktop and go to the Settings
- From `Resources`, select `Proxies`
- Enable `Manual proxy configuration`
- Enter your proxy settings, e.g.:
  - Web Server (HTTP): `http://localhost:3128`
  - Secure Web Server (HTTPS): `http://localhost:3128`
  - Bypass: `localhost,127.0.0.1`
- Apply & Restart.

# Environment Variables

It is required to set the following environment variables:

- `HTTP_PROXY` - proxy server, e.g. `http://localhost:3128`
- `HTTPS_PROXY` - secure proxy server, e.g. `http://localhost:3128`
- `DEVCONTAINER_PROXY` - Enables proxy configuration for the devContainer. Please use `.Proxy` as value and don't forget (dot).

If you are running on Unix you have to define in addition the environment variable `DEVCONTAINER_PROXY_HOST` to define the internal docker host `172.17.0.1`.

In addition you have the opportunity to use the environment variable `DEVCONTAINER_PROXY_PORT` to define the port in case your proxy is running on a different port than `3128`.


{{< tabpane text=true >}}
{{% tab header="Windows" %}}
```bash
set
setx DEVCONTAINER_PROXY ".Proxy"
setx HTTP_PROXY "http://localhost:3128"
setx HTTPS_PROXY "http://localhost:3128"
```
{{% /tab %}}
{{% tab header="MacOS" %}}
```bash
echo "export DEVCONTAINER_PROXY=.Proxy" >> ~/.bash_profile
echo "export HTTP_PROXY=http://localhost:3128" >> ~/.bash_profile
echo "export HTTPS_PROXY=http://localhost:3128" >> ~/.bash_profile
source ~/.bash_profile
```
{{% /tab %}}
{{% tab header="Linux" %}}
```bash
echo "export DEVCONTAINER_PROXY=.Proxy" >> ~/.bash_profile
echo "export HTTP_PROXY=http://localhost:3128" >> ~/.bash_profile
echo "export HTTPS_PROXY=http://localhost:3128" >> ~/.bash_profile
echo "export DEVCONTAINER_PROXY_HOST=172.17.0.1" >> ~/.bash_profile
source ~/.bash_profile
```
{{% /tab %}}
{{< /tabpane >}}

# Visual Studio Code

A template configuration using proxy settings is provided by our template repository with `.devcontainer/Dockerfile.Proxy`. By setting the environment variable `DEVCONTAINER_PROXY` to `.Proxy` the file
`.devcontainer/Dockerfile.Proxy` will be used instead of `.devcontainer/Dockerfile`.

{{% alert title="Troubleshooting" %}}

- If you experience issues during initial DevContainer build, than clean all images and volumes in Docker Desktop, otherwise cache might be used. 
   - Open Docker Desktop 
   - From `Troubleshooting` choose `Clean / Purge data`



- Check the value in `~/.docker/config.json` contains the following content, for more details see [Docker Documentation](https://docs.docker.com/network/proxy/):

   ```json
   {
    "proxies":{
         "default":{
            "httpProxy":"http://host.docker.internal:3128",
            "httpsProxy":"http://host.docker.internal:3128",
            "noProxy":"host.docker.internal,localhost,127.0.0.1"
         }
      }
   }
   ```

{{% /alert %}}