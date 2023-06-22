---
title: "Troubleshooting"
date: 2023-02-13T09:43:25+05:30
weight: 4
description: >
  Known issues and fixes.
---

### GitHub rate limit exceeded

To avoid exceeding GitHubs rate limit we suggest to generate a personal access token in your [GitHub settings](https://github.com/settings/tokens) and set it as an environment variable:

{{< tabpane text=true >}}
{{% tab header="Mac/Linux" %}}
`export GITHUB_API_TOKEN=<your_api_token>`
{{% /tab %}}
{{% tab header="Windows" %}}
`set GITHUB_API_TOKEN=<your_api_token>`
</br>
or
</br>
Set environment variable via system settings GITHUB_API_TOKEN=<your_api_token>
{{% /tab %}}
{{< /tabpane >}}

After you have set the ENV consider to restart VS Code.

It is important that VS Code has access to this ENV during the `postCreateCommand` inside the devcontainer.
If you experienced this error and the devcontainer still has started correctly please run either:

```bash
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ ./.devcontainer/scripts/postCreateCommand.sh
```

or

```bash
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ velocitas init
vscode ➜ /workspaces/eclipse-vehicle-app-python-template (main) $ velocitas sync
```
