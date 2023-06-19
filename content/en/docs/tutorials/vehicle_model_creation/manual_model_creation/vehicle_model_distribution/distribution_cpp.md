---
title: "C++ Vehicle Model Distribution"
date: 2022-05-09T13:43:25+05:30
weight: 20
description: >
  Learn how to distribute a Vehicle Model written in C++.
aliases:
  - /docs/tutorials/vehicle_model_creation/manual_model_creation/distribution_cpp.md
---

Now that you have created your own Vehicle Model, we can distribute it to make use of it in _Vehicle Apps_.

## Copying the folder to your _Vehicle App_ repo

The easiest way to get started quickly is to copy the created model, presumably stored in `vehicle_model` into your _Vehicle App_ repository to use it. To do so, simply copy and paste the directory into the `<sdk_root>/app` directory and replace the existing model.

## Using a git submodule

A similar approach to the one above but a bit more difficult to set up is to create a git repository for the created model. The advantage of this approach is that you can share the same model between multiple _Vehicle Apps_ without any manual effort.

1. Create a new git repository on i.e. [Github](https://github.com)
2. Clone it locally, add the created `vehicle_model` folder to the git repository
3. Commit everything and push the branch

In your _Vehicle App_ repo, add a new git submodule via

```bash
git submodule add <checkout URL of your new repo> app/vehicle_model
git submodule init
```

Now you are ready to develop new _Vehicle Apps_ with your custom Vehicle Model!
