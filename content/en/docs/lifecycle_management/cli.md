---
title: "CLI"
weight: 2
date: 2023-02-13T09:43:25+05:30
aliases:
  - /docs/tutorials/cli.md
---

## Installation

The [velocitas CLI](https://github.com/eclipse-velocitas/cli) is installed inside our [devcontainer-base-images](https://github.com/eclipse-velocitas/devcontainer-base-images)
</br>
After creation of a devcontainer a [postCreateCommand](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.devcontainer/scripts/postCreateCommand.sh#L18) is configured to be executed which for the first time runs our velocitas cli with `velocitas init` and `velocitas sync`

## Usage

- Purpose of `velocitas init`:

  Checks content of `.velocitas.json` and downloads configured packages to `/home/user/.velocitas/packages/<package_name>`

- Purpose of `velocitas sync`:

  Checks content of `/home/user/.velocitas/packages/<package_name>` and synchronizes files inside the Vehicle App repository

- Purpose of `velocitas upgrade`:

  Compares versions installed/configured inside `.velocitas.json` with latest version of respective package repository

- Purpose of `velocitas package`:

  Lists installed packages and scripts inside of `/home/user/.velocitas/packages`

- Purpose of `velocitas exec`:

  Executes scripts found inside of specific package `/home/user/.velocitas/packages/<package_name>`

## Additional Information

### Cache Usage

`echo "foo=bar >> VELOCITAS_CACHE"`
</br>
`print(f"foo='{bar}' >> VELOCITAS_CACHE")`
</br>
`foo=$(echo $VELOCITAS_PROJECT_CACHE_DATA | jq .bar | tr -d '"')`
</br>
CLI also detects AppManifest data and saves it in ENV `VELOCITAS_APP_MANIFEST`

## Implementation

[CLI repository](https://github.com/eclipse-velocitas/cli)

available commands:

- [velocitas help](https://github.com/eclipse-velocitas/cli#velocitas-help-command)
- [velocitas init](https://github.com/eclipse-velocitas/cli#velocitas-init)
- [velocitas upgrade](https://github.com/eclipse-velocitas/cli#velocitas-upgrade)
- [velocitas sync](https://github.com/eclipse-velocitas/cli#velocitas-sync)
- [velocitas package](https://github.com/eclipse-velocitas/cli#velocitas-package-name)
- [velocitas exec](https://github.com/eclipse-velocitas/cli#velocitas-exec-component-id-args)
