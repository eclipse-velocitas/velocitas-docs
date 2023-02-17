---
title: "Troubleshooting"
date: 2023-02-13T09:43:25+05:30
weight: 4
description: >
  Known issues and fixes.
aliases:
  - /docs/concepts/lifecycle_management/troubleshooting.md
---

### GitHub rate limit exceeded

To avoid exceeding GitHubs rate limit we suggest to generate a personal access token in your [GitHub settings](https://github.com/settings/tokens) and set it in your environment variables:

{{< tabpane text=true >}}
{{% tab header="Mac/Linux" %}}
`export GITHUB_API_TOKEN=<your_api_token>`
{{% /tab %}}
{{% tab header="Windows" %}}
Set environment variable via system settings and restart VSCode.
</br>
GITHUB_API_TOKEN=<your_api_token>
{{% /tab %}}
{{< /tabpane >}}
