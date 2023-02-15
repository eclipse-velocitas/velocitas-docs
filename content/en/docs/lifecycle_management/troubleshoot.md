---
title: "Troubleshoot"
date: 2023-02-13T09:43:25+05:30
weight: 4
description: >
  Known issues and fixes.
aliases:
  - /docs/lifecycle_management/troubleshoot.md
---

### Proxy usage

When working behind a proxy and to avoid exceeding GitHubs rate limit we suggest to generate a personal access token in your [GitHub settings](https://github.com/settings/tokens) and set it in your environment variables:

`export GITHUB_API_TOKEN=<your_api_token>`

on windows (via system settings) then restart VSCode
