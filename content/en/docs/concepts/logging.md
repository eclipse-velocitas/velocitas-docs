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

An app or a service is a **long running, self-contained application** which is inheritly not designed to execute and terminate quickly such that its output may be piped into other programs. Therefore, stdout is free to be used for log levels, since there is no "regular output".

`Error` and `Critical` need to be written to `stderr` as they may need to be monitored by external application health checkers.
`Debug` and `Info` are used for diagnostic and informational prints only, hence they are written to `stdout`.
`Warning` has a special role since it is neither only informational nor does it indicate that something the application was asked for has not been done. But since we want warnings to be monitorable as well and they are not part of regular state reporting of an application on `stdout` we chose to write `Warning` to `stderr`.

Here the overview in table form:
{{<table "table table-bordered">}}
| Level | Target |
|:------|-------:|
Debug   | stdout
Info    | stdout
Warning | stderr
Error   | stderr
Critical| stderr
{{</table>}}

## References

* https://julienharbulot.com/python-cli-streams.html
* https://sematext.com/blog/logging-levels/
* https://softwareengineering.stackexchange.com/questions/439462/log-levels-and-stdout-vs-stderr
