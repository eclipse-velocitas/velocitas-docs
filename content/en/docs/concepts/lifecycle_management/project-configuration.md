---
title: "Project Configuration"
date: 2023-02-13T09:43:25+05:30
weight: 1
description: >
  Learn everything about Velocitas project configuration.
aliases:
  - /docs/concepts/lifecycle_management/project-configuration.md
---

Every _Vehicle App_ repo comes with a [`.velocitas.json`](https://github.com/eclipse-velocitas/vehicle-app-python-template/blob/main/.velocitas.json) which is the project configuration of your app. It holds references to the packages and their respective versions you are using in your project.

Here is an example of this configuration:

```json
{
  "packages": [
    {
      "name": "devenv-devcontainer-setup",
      "version": "v1.0.0"
    },
    {
      "name": "devenv-runtime-local",
      "version": "v1.0.0"
    }
  ],
  "variables": {
    "foo": "bar",
    "baz": 2
  }
}
```

### Packages

Each package entry has the following fields:

{{<table "table table-bordered">}}
| name | type | description |
|:--------|:--------|:---------------|
| name | string | Can either be a fully qualified https URL to a git repository e.g. `https://my-organization/repos/my-velocitas-package.git` or a short name e.g. `devenv-devcontainer-setup` which would then be resolved to `https://github.com/eclipse-velocitas/<name>`|
| version | string | A git reference. May either be a tag, branch name or SHA. If it is a tag and your remote repository has valid semver tags, the CLI will suggest newer versions when running `velocitas upgrade`|
{{</table>}}

### Variables

{{<table "table table-bordered">}}
| name | type | description |
|:--------|:--------|:---------------|
| variables | list | Key-Value pair|
{{</table>}}

</br>

Each variable configured at the root of your project configuration applies to all packages and their components. Variables configured at package level apply to the whole package they are configured for. Finally, variables configured at component level apply to a single component only.

Each variable is a key-value pair which maps the variable to a particular value. In the example above, the variable named `foo` is mapped to the string value `"bar"` whereas the variable named `baz` is mapped to the numeric value `5`.

## Next steps

* Lifecycle Management: [Usage of Packages](/docs/concepts/lifecycle_management/packages/usage/)
* Lifecycle Management: [Development of Packages](/docs/concepts/lifecycle_management/packages/development/)
