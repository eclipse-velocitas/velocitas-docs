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
- Open _Docker Desktop_ and go to the Settings
- From `Resources`, select `Proxies`
- Enable `Manual proxy configuration`
- Enter your proxy settings, e.g.:
  - Web Server (HTTP): `http://localhost:3128`
  - Secure Web Server (HTTPS): `http://localhost:3128`
  - Bypass: `localhost,127.0.0.1,.example.com`
- Apply & Restart.

Please replace the values with our specific values (at least replace example.com in the Bypass value with your domain).

# Environment Variables

It is required to set the following environment variables:

- `HTTP_PROXY` - proxy server, e.g. `http://localhost:3128`
- `HTTPS_PROXY` - secure proxy server, e.g. `http://localhost:3128`
- `DEVCONTAINER_PROXY` - Enables proxy configuration for the devContainer. Please use `.Proxy` as value and don't forget (dot).


{{< tabpane text=true >}}
{{% tab header="Windows" %}}
```bash
set
setx DEVCONTAINER_PROXY ".Proxy"
setx http_proxy "http://localhost:3128"
setx https_proxy "http://localhost:3128"
```
{{% /tab %}}
{{% tab header="MacOS & Linux" %}}
```bash
echo "export DEVCONTAINER_PROXY=.Proxy" >> ~/.bash_profile
echo "export http_proxy=http://localhost:3128" >> ~/.bash_profile
echo "export https_proxy=http://localhost:3128" >> ~/.bash_profile
source ~/.bash_profile
```
{{% /tab %}}
{{< /tabpane >}}

# Visual Studio Code

A template configuration using proxy settings is provided by our template repository with `.devcontainer/Dockerfile.Proxy`. By setting the environment variable `DEVCONTAINER_PROXY` to `.Proxy` the file
`.devcontainer/Dockerfile.Proxy` will be used instead of `.devcontainer/Dockerfile`.

{{% alert title="Troubleshooting" %}}
- If you are running in Linux and expierence issues with the internal docker host proxy, please set the   `DEVCONTAINER_PROXY_HOST` environment variable to the internal docker host.

- If you are trying to connect to a proxy which is running on a different port than `3128`, please use the `DEVCONTAINER_PROXY_Port` environment variable to define the port.

- If you experience issues during initial DevContainer build, than clean all images and volumes in Docker Desktop, otherwise cache might be used. Use the Docker Desktop UI `Troubleshooting` >  `Clean / Purge data`

- Proxy settings in `~/.docker/config.json` will override settings in `.devcontainer/Dockerfile.Proxy`, which can cause problems. In case the DevContainer is still not working, check if proxy settings are set correctly in the Docker user profile (`~/.docker/config.json`), for more details see [Docker Documentation](https://docs.docker.com/network/proxy/).
   ```json
   {
    "proxies":
    {
      "default":
      {
        "httpProxy": "http://localhost:3128",
        "httpsProxy": "http://localhost:3128",
        "noProxy": "localhost,127.0.0.1,.example.com"
      }
    }
   }
   ```

- If you are using `noProxy` setting in `~/.docker/config.json` verify that it is compatible with the setting of `NO_PROXY` in `.devcontainer/Dockerfile.Proxy`.
The development environment relies on communication to localhost (e.g. localhost, 127.0.0.1) and it is important that the proxy setting is correct so that connections to localhost are not forwarded to the proxy.

{{% /alert %}}