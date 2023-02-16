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

## Usage

{{<table "table table-bordered">}}
| command | purpose |
|:--------|:--------|
|[`velocitas init`](https://github.com/eclipse-velocitas/cli#velocitas-init)|Checks content of `.velocitas.json` and downloads configured packages to `~/.velocitas/packages/<package_name>`.|
|[`velocitas sync`](https://github.com/eclipse-velocitas/cli#velocitas-sync)|Checks content of `~/.velocitas/packages/<package_name>` and synchronizes files inside the _Vehicle App_ repository.|
|[`velocitas upgrade`](https://github.com/eclipse-velocitas/cli#velocitas-upgrade)|Compares installed/configured versions inside `.velocitas.json` with latest version of respective package repository.|
|[`velocitas package`](https://github.com/eclipse-velocitas/cli#velocitas-package-name)|Lists installed packages and scripts inside of `~/.velocitas/packages`.|
|[`velocitas exec`](https://github.com/eclipse-velocitas/cli#velocitas-exec-component-id-args)|Executes programs of a component found inside of specific package `~/.velocitas/packages/<package_name>`.|
{{</table>}}

## Additional Information

### Cache Usage

The CLI supports to cache data for a _Vehicle App_ project.
The cache data makes it easy for any script/program of a component to read from or write to.

The CLI creates default environment variables which are available to every script/program.

{{<table "table table-bordered">}}
| variable | description |
|:--------|:--------|
|`VELOCITAS_WORKSPACE_DIR`| Current working directory of the _Vehicle App_ |
|`VELOCITAS_CACHE_DIR`| _Vehicle App_ project specific cache directory. e.g, `~/.velocitas/cache/<generatedMd5Hash>` |
|`VELOCITAS_CACHE_DATA`| JSON string of `~/.velocitas/cache/<generatedMd5Hash>/cache.json` |
|`VELOCITAS_APP_MANIFEST`| JSON string of the _Vehicle App_ AppManifest |
{{</table>}}

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

## Next steps

- Lifecycle Management: [Troubleshooting](/docs/lifecycle_management/troubleshooting/)
