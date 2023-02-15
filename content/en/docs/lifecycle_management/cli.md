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

## Background

Our [Velocitas CLI](https://github.com/eclipse-velocitas/cli) is introduced to support the process of the lifecycle of a _Vehicle App_ as a package manager.
It is written in TypeScript and based on the open CLI framework [oclif](https://oclif.io/).

## Additional Information

### Cache Usage

The CLI supports to cache data for a _Vehicle App_ project.
The cache data makes it easy for any script/program of a component to read from or write to.

The CLI creates default environment variables which are available to every script/program.

| variable | description |
|:--------:|:--------:|
|`VELOCITAS_WORKSPACE_DIR`| Current working directory of the _Vehicle App_ |
|`VELOCITAS_CACHE_DIR`| _Vehicle App_ project specific cache directory. e.g, `~/.velocitas/cache/<generatedMd5Hash>` |
|`VELOCITAS_CACHE_DATA`| JSON string of `~/.velocitas/cache/<generatedMd5Hash>/cache.json` |
|`VELOCITAS_APP_MANIFEST`| JSON string of the _Vehicle App_ AppManifest |

#### Writing to Cache inside of a component script

```python
echo "foo=bar >> VELOCITAS_CACHE"
```

```python
print(f"foo='{bar}' >> VELOCITAS_CACHE")
```

#### Reading from Cache or AppManifest inside of a component script

```python
# From cache data
foo = json.loads(require_env('VELOCITAS_CACHE_DATA'))['foo']
# From AppManifest
manifest_data_str = os.getenv('VELOCITAS_APP_MANIFEST')
manifest_data = json.loads(manifest_data_str)
baz = manifest_data['foo']['bar']['baz']
```

```bash
# From cache data
FOO=$(echo $VELOCITAS_CACHE_DATA | jq .foo | tr -d '"')
# From AppManifest
BAZ=$(echo $VELOCITAS_APP_MANIFEST | jq .foo.bar.baz | tr -d '"')
```

## Implementation

[CLI repository](https://github.com/eclipse-velocitas/cli)

available commands:

- [velocitas help](https://github.com/eclipse-velocitas/cli#velocitas-help-command)
- [velocitas init](https://github.com/eclipse-velocitas/cli#velocitas-init)
- [velocitas upgrade](https://github.com/eclipse-velocitas/cli#velocitas-upgrade)
- [velocitas sync](https://github.com/eclipse-velocitas/cli#velocitas-sync)
- [velocitas package](https://github.com/eclipse-velocitas/cli#velocitas-package-name)
- [velocitas exec](https://github.com/eclipse-velocitas/cli#velocitas-exec-component-id-args)
