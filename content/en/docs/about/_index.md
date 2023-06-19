---
title: "About Velocitas"
date: 2022-08-24T17:24:56+05:30
weight: 10
description: >
  Explore the goal, benefits and basic concepts of Eclipse _Velocitas™_
---

## Problem

Currently, the development of in-vehicle applications (_Vehicle Apps_) can be excessively complex and challenging:

{{%beside "time.png" "Many time-consuming steps involved from setting up the development environment to the deployment of a <i>Vehicle App</i>."%}}
{{%beside "knowledge.png" "Understanding the vehicle's E/E architecture details and specific API requires expert knowledge."%}}
{{%beside "porting.png" "Porting a _Vehicle App_ to another vehicle platform is complex."%}}
{{%beside "collab.png" "Specific processes, methods, and tools within each company creates challenges for effective collaboration."%}}

## Solution

The solution would be a development toolchain for creating vehicle-independent applications with:

{{<beside "unified.png" "Usage of standardized vehicle APIs.">}}
{{<beside "containerization.png" "Enabling portability through containerized _Vehicle Apps_ with no dependencies to E/E architecture.">}}
{{<beside "setup.png" "Pre-configured project setup​.">}}
{{<beside "simulation.png" "Speeding up the development by reducing complexity focus on differentiating business logic to innovate quickly.">}}

## Product

Eclipse _Velocitas™_ is an open source project providing an end-to-end, scalable and modular development tool chain to create containerized _Vehicle Apps_, offering a comfortable, fast and efficient development experience to increase the speed of a development team (velocity).

<img src="dev_ops_cycle.png" >

## Features

- **Project lifecycle management** to update _Vehicle App_ repositories via CLI.
- **Vehicle abstraction support** helps to focus on business logic by using a generated vehicle model _on code level_ with type safety and auto-completion. The vehicle model is generated from a standardized API that hides the details of vehicle-specific signals and E/E architecture, allowing _Vehicle Apps_ to be portable across different electronics and software architectures.
- Microsoft **Visual Studio Code integration** with DevContainer helps to install everything required to start the local development immediately, while tasks and launch configurations help to launch runtime services, other apps, and tests.
- **_Vehicle App_ skeleton and examples** helps to understand easily how to write a _Vehicle App_ using the KUKSA.VAL runtime services.
- Ready-to-use **CI/CD workflows** that build (for multi architectures), test, document and deploy a containerized _Vehicle App_ with no dependencies to E/E architecture help saving setup time.

## Language Support

{{<table "table table-bordered">}}
| Feature                            | Python | C++ |
|------------------------------------|--------|-----|
| Project lifecycle management       | +      | +   |
| Vehicle abstraction support        | +      | +   |
| Visual Studio Code integration     | +      | +   |
| _Vehicle App_ skeleton and examples| +      | +   |
| CI/CD workflows                    | +      | +   |
| Unit test support                  | +      | +   |
| Integration test support           | +      |     |
| digital.auto integration           | +      |     |
{{</table>}}

## Concepts
