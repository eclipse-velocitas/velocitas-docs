---
title: "Vehicle Model Creation"
date: 2023-03-08T11:12:00+01:00
weight: 40
description: >
  Learn how creation of vehicle models work and how to adapt it to your needs.
---

{{% alert title="Info" %}} On Friday, 2023-03-03 we released our new [model lifecycle approach](automated_model_lifecycle/). With the update of the documentation the previous content of this page can be found in the section [Manual Vehicle Model Creation](manual_model_creation/) now.
{{% /alert %}}

A _Vehicle Model_ makes it possible to easily get vehicle data from the KUKSA Data Broker and to execute remote procedure calls over gRPC against _Vehicle Services_ and other _Vehicle Apps_. It is generated from the underlying semantic models based on the [COVESA Vehicle Signal Specification (VSS)](https://covesa.github.io/vehicle_signal_specification/). The model is generated for a concrete programming language as a graph-based, strongly-typed, intellisense-enabled library providing vehicle abstraction "on code level".

By default our app templates now generate the vehicle model during the devContainer initialization - managed by the Velocitas life cycle management. The respective VSS-based model source is referenced in the app manifest allowing to freely choose the model being used in your project. You will find more details about this in section [Automated Model Lifecycle](automated_model_lifecycle/).

The previous approach, using pre-generated model repositories, is deprecated as of now. But is still available and is described in section [Manual Vehicle Model Creation](manual_model_creation/). Please be aware, that you would either have to use template versions before the above mentioned release, or you need to adapt the newer versions of the template using the old approach.
