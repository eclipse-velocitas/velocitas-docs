---
title: "Logging guidelines"
date: 2023-07-03T00:00:00+01:00
weight: 200
description: >
  How logging shall be handled by Vehicle Applications.
---

Rationale: Logging application behavior is absolutely necessary for monitoring applications and also track down possible issues.

## Levels

In Velocitas, we establish the following log levels, ordered from lowest to highest priority:

{{<table "table table-bordered">}}
| Level | Purpose | Examples
|:------|:-------|:-----
Debug   | Display of information to aid debugging of live systems like resolved values, executed lines of code, taken branches etc... | `"variable=5"`,<br/> `"executing branch debug==false"`
Info    | Display of regular, user friendly messages to indicate the current state of the application. | `"Startup successful"`,<br/> `"Application ready"`
Warning | Deviation from *optimal* program flow which is tolerable by the application, but not recommended. | `"Memory usage exceeding upper bounds!"`,<br/>`"Usage of deprecated API"`
Error   | Display of a type of failure that is not expected and can lead to unexpected or degraded behavior which may lead to program termination. | `"Memory allocation failed!"`, <br/>`"Unable to persist data"`
Critical | Display of a failure which leads to system unavailablity due to a missing feature, i.e. a database connection. | `"Database not available"`,<br/>`"Unable to establish connection to server!"`
{{</table>}}

## Destination of log levels

### Historically

On *nix systems the philosophy is for programs to be as silent as possible by default. stdout is reserved for *regular* program output. Logging is **never** regular program output, it is there for diagnostic reasons

See the ls program as an example:

```bash
ls
integration  logs  requirements.txt
```

Regular output is written to stdout and should not be poluted by logging because it is designed to be pipeable into other programs.

### What does this mean for Vehicle Apps/Services?

An app or a service is a **long running, self-contained application** which is inheritly not designed to execute and terminate quickly such that its output may be piped into other programs. Therefore, stdout would be free to be used for log levels, since there is no "regular output".

However, due to the inherent nature of logs not being regular problem output and the issue of potentially re-ordering messages when they are directed to different files, in Velocitas we chose to output all logs to `stderr`:

Here the overview in table form:
{{<table "table table-bordered">}}
| Level | Target file |
|:------|-------:|
Debug   | stderr
Info    | stderr
Warning | stderr
Error   | stderr
Critical| stderr
{{</table>}}

## References

* https://julienharbulot.com/python-cli-streams.html
* https://sematext.com/blog/logging-levels/
* https://softwareengineering.stackexchange.com/questions/439462/log-levels-and-stdout-vs-stderr
