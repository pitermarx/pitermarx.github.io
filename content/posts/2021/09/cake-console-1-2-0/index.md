---
title: "Cake.Console 1.2.0"
date: "2021-09-09"
categories:
  - "longs"
  - "original"
tags:
  - "dev"
---

After a bit of work, I have found [Cake.Console]({{< ref "/posts/2021/09/presenting-cake-console" >}}) stable enough for a [first release](https://www.nuget.org/packages/Cake.Console/). I decided to version it with the same number as Cake itself. If needed I will update the revision number.

## Usage

Create a new project referencing Cake.Console. It will look something like this

```
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net5.0</TargetFramework>
    <OutputType>exe</OutputType>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Cake.Console" Version="1.2.0" />
  </ItemGroup>
</Project>
```

Add a single Program.cs file with the code. Take advantage of [top-level statements](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/program-structure/top-level-statements).

There are 2 ways of using Cake.Console:

1. Building an IScriptHost. This is the implicit object in the .cake scripts, so we can use it to register tasks, perform setup, etc.

```
var host = new CakeHostBuilder().BuildHost(args);

host.Setup(() => { do something });
host.Task("TaskName").Does(c => c.Information("Hello"));
host.RunTarget(host.Context.Arguments.GetArgument("target"));
```

2. Using the Cake Cli, that includes arguments like --target, --version, --info, --tree, --description, --exclusive…
    It's very similar to [frosting](https://cakebuild.net/docs/running-builds/runners/cake-frosting)

```
new CakeHostBuilder()
    .WorkingDirectory<WorkingDirectory>()
    .ContextData<BuildData>()
    .RegisterTasks<CakeTasks>()
    .InstallNugetTool("NuGet.CommandLine", "5.9.1")
    .RunCakeCli(args);
```

In this case, we dont have access to the host, so we need to define the build with the 4 extensions that come with Cake.Console:

- WorkingDirectory<>
- RegisterTasks<>
- ContextData<>
- InstallNugetTool

## WorkingDirectory<>

Here we can use a class that has the interface IWorkingDirectory and implements the string WorkingDirectory property.

The class can receive in the constructor any part of the cake infrastructure (ICakeContext, ICakeLog, ICakeArguments, ICakeConfiguration…)

## RegisterTasks<>

Here we can use a class that has the interface ICakeTasks.

The class can receive in the constructor any part of the cake infrastructure (ICakeContext, ICakeLog, ICakeArguments, ICakeConfiguration…)

All the methods that have the signature `void Name(CakeTaskBuilder builder)` will be called, and the name of the method will be the name of the task.

## ContextData<>

Here we can use any class that will then be available for use in the task's definitions.

## InstallNugetTool

Given a package name and a version, installs a nuget package as a [Cake tool](https://cakebuild.net/docs/writing-builds/tools/installing-tools)

# Summary

Putting it all together

```
using Cake.Common.Diagnostics;
using Cake.Console;
using Cake.Core;

new CakeHostBuilder()
    .WorkingDirectory<WorkingDir>()
    .ContextData<ContextData>()
    .RegisterTasks<CakeTasks>()
    .InstallNugetTool("xunit.runner.console", "2.4.1")
    .RunCakeCli(args);

record WorkingDir(string WorkingDirectory = ".") : IWorkingDirectory;

class ContextData
{
    public string SomeVeryImportantData { get; set; } = "Cake is awesome!";
    public ContextData(ICakeArguments args)
    {
        if (args.HasArgument("tone-down"))
        {
            SomeVeryImportantData = "Cake is pretty good...";
        }
    }
}


class CakeTasks : ICakeTasks
{
    private readonly ICakeContext ctx;

    public CakeTasks(ICakeContext ctx) => this.ctx = ctx;

    public void TaskName(CakeTaskBuilder b) => b
        .Description("Some task")
        .Does(() => ctx.Information("Something"));

    public void AnotherTask(CakeTaskBuilder b) => b
        .IsDependentOn(nameof(TaskName))
        .Does<ContextData>(data => ctx.Information(data.SomeVeryImportantData));
}
```
