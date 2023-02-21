---
title: "Working behind proxy"
date: 2022-08-19T17:46:21+05:30
weight: 2
description: >
  Learn how to setup your docker desktop and Visual Studio Code behind a coorperate proxy.
---

We know what a pain and how time consuming it can be to setup your environment behind a cooperate proxy. This guide will help you to set it up correctly.

Be aware that correct proxy configuration depends on the setup of your organisation and of course of your personal development environment (hardware, OS, virtualization setup, ...). So, we most probably do not cover all issues out there in the developers world. So, we encourage you to share hints and improvements with us.

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
- Enter your proxy settings, this depends on the configuration you did while setting up your proxy tool e.g.:
  - Web Server (HTTP): `http://localhost:3128`
  - Secure Web Server (HTTPS): `http://localhost:3128`
  - Bypass: `localhost,127.0.0.1`
- Apply & Restart.

# Docker daemon

You also have to configure the Docker daemon, which is running the containers basically, to forward the proxy settings. For this you have to add the proxy configuration to the `~/.docker/config.json`. Here is an example of a proper config (Port and noProxy settings might differ for your setup):

   {{< tabpane text=true >}}
   {{% tab header="Windows & MacOS" %}}

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

   {{% /tab %}}
   {{% tab header="Linux" %}}

   ```json
   {
    "proxies":{
         "default":{
            "httpProxy":"http://172.17.0.1:3128",
            "httpsProxy":"http://172.17.0.1:3128",
            "noProxy":"host.docker.internal,localhost,127.0.0.1"
         }
      }
   }
   ```

   {{% /tab %}}
   {{< /tabpane >}}

For more details see: [Docker Documentation](https://docs.docker.com/network/proxy/)

# Environment Variables

It is required to set the following environment variables:

- `HTTP_PROXY` - proxy server, e.g. `http://localhost:3128`
- `HTTPS_PROXY` - secure proxy server, e.g. `http://localhost:3128`

{{< tabpane text=true >}}
{{% tab header="Windows" %}}

```bash
set
setx HTTP_PROXY "http://localhost:3128"
setx HTTPS_PROXY "http://localhost:3128"
```

{{% /tab %}}
{{% tab header="MacOS" %}}

```bash
echo "export HTTP_PROXY=http://localhost:3128" >> ~/.bash_profile
echo "export HTTPS_PROXY=http://localhost:3128" >> ~/.bash_profile
source ~/.bash_profile
```

{{% /tab %}}
{{% tab header="Linux" %}}

```bash
echo "export HTTP_PROXY=http://localhost:3128" >> ~/.bash_profile
echo "export HTTPS_PROXY=http://localhost:3128" >> ~/.bash_profile
source ~/.bash_profile
```

{{% /tab %}}
{{< /tabpane >}}

# Solving issues with TLS (SSL) certificate validation using https connections from containers

If you are behind a so-called intercept proxy (which you most probably are), you can run into certificate issues:
Your corporate proxy works as a "man-in-the-middle" to be able to check the transfered data for malicious content.
Means, there is a protected connection between the application in your local runtime environment and the proxy and
another from the proxy to the external server your application wants to interact with.

For the authentication corporate proxies often use self-signed certificates (certificates which are not signed by
a (well-known official) certificate authority. Those kind of certificates need to be added to the database of
trusted certificates of your local runtime environment. This task is typically handled by the IT department of
your corporation (if the OS and software installed on it is managed by them) and you will not run into problems,
normally.

If it comes to executing containers, those are typically not managed by your IT department and the proxy certificate(s)
is/are missing. So, you need to find a way to install those into the (dev) container you want to execute.

See (one of) those articles to get how to achieve that:
<https://www.c2labs.com/post/overcoming-proxy-issues-with-docker-containers>
<https://technotes.shemyak.com/posts/docker-behind-ssl-proxy/>

# Troubleshooting

### Initial DevContainer build issue

If you experience issues during initial DevContainer build, clean all images and volumes otherwise cache might be used:

- Open Docker Desktop
- From `Troubleshooting` choose `Clean / Purge data`

### GitHub rate limit exceeded

How to fix can be found at [Lifecycle Management Troubleshooting](/docs/concepts/lifecycle_management/troubleshooting/#github-rate-limit-exceeded).
