---
title: "Generating an Eclipse Velocitas Project"
date: 2022-11-02T10:09:25+05:30
weight: 2
description: >
  Learn how to generate an Eclipse Velocitas Project
---

In the previous step you started with envision and prototyping your vehicle app idea. You tested the signals against mocked vehicle components. Now it's time to transfer it into your [Development Environment]({{< ref "/docs/tutorials/quickstart/#creating-vehicle-app-repository" >}}) directly out of the [playground.digital.auto](https://digitalauto.netlify.app/) and test it with real [_Vehicle Services_]({{< ref "/docs/about/development_model/val/#vehicle-services" >}}). Here [Eclipse Velocitas](https://websites.eclipseprojects.io/velocitas/) comes into the game. We are providing a project generator that allows you to generate a Vehicle Application GitHub repository from your previously created prototype code based on our [vehicle-app-python-template](https://github.com/eclipse-velocitas/vehicle-app-python-template).

## Transfer your prototype into a vehicle application

In the 'Code' section of your prototype in the [playground.digital.auto](https://digitalauto.netlify.app/) you have the Button 'Create Eclipse Velocitas Project'.
If you press this button you will be forwarded to [GitHub](https://github.com/) to login with your GitHub Account and authorize _velocitas-project-generator_ to create the repository for you. After you authorized the project generator you will be redirected to the [playground.digital.auto](https://digitalauto.netlify.app/) and asked for a repository name (Which also is the app's name). After pressing "Create repository" the project generator takes over your prototype code, adapts it to the structure in the [vehicle-app-python-template](https://github.com/eclipse-velocitas/vehicle-app-python-template) and creates a new private repository under your GitHub User.

![generate](../generate.png)

If you would like to know what exactly the generator is doing, please have a look in the code: [velocitas-project-generator-npm](https://github.com/eclipse-velocitas/velocitas-project-generator-npm). Feedback is welcome :)

After the generation of the repository is completed a pop-up dialogue with the URL of your repository will be displayed. Among other things the newly created repository will contain:

- _/app/src/main.py_ containing your modified prototype code
- _/app/AppManifest.json_ with definition of required services
- _/app/requirements.txt_ with definition of dependecies
- _/.devcontainer_/ required scripts to install every prerequisites in Microsoft Visual Studio Code
- _/.github/workflows/_ with all required CI/CD pipelines to build, test and deploy the vehicle application as container image to the GitHub container registry

**Note**: By default the template repository comes with automated CodeQL Analysis to automatically detect common vulnerabilities and coding errors. It is available if you have a [GitHub advanced security](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security) license in your org or if your repository is public. To do so: Go to your repository settings -> General -> Danger Zone (at the bottom) -> Change repository visibility -> Change visibility to public.

**Next step:** [Extend the prototype]({{< ref "/docs/tutorials/prototyping/extending" >}})
