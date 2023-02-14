---
title: "CLI"
weight: 3
date: 2023-02-13T09:43:25+05:30
description: >
  Learn everything about the Velocitas CLI.
aliases:
  - /docs/lifecycle_management/cli.md
  - /docs/lifecycle_management/cli
---

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
