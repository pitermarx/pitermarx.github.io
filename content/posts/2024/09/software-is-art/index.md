---
title: "Software is art"
date: "2024-09-30"
categories:
  - "longs"
  - "original"
tags:
  - "dev"
---

My workstation at my job is not a local computer. Its a remote virtual machine that I connect to through the internet.

For the most part it works fine, but it is highly sensitive to network latency fluctuations.
I was having a bad experience with it, so I decided to measure my network latency by pinging google.com.

Being a nerd, I also decided this was a good opportunity to [learn F#](https://fsharp.org/)! I must say I fell in love with this language.

I ended up having an ASP.NET web app, running a Background service, that pings google, and saves the latency data into a [SQLite](https://sqlite.org/) Database.
It then serves a webapge that can show me a chart drawn with [plotly](https://plotly.com/javascript/).
I chose [Oxpecker](https://github.com/Lanayx/Oxpecker/) as my web framework after experimenting with [Giraffe](https://giraffe.wiki/), [Falco](https://www.falcoframework.com/) and [Suave](https://suave.io/) as it "felt right".
For me i had the right balance between F# constructs and familiar C# ASP.NET ones.
The [ViewEngine](https://github.com/Lanayx/Oxpecker/blob/develop/src/Oxpecker.ViewEngine/README.md) library is also a joy to use!

I spent way too much time with this project, tinkering with the components to my liking to get a feel of the language.
In the end, this is what I'm most proud of: An ADO.NET wrapper to access SqLite.

```fs
module Sql
open System.Data.Common
open System.Data.SQLite
open System.Data

type IDataRecord with
  member x.GetOption(index, f: (IDataRecord -> int32 -> 't)) = 
    if x.IsDBNull(index) then None else Some(f x index)

let withParam name (value: 'T) f (cmd: DbCommand) =
    let param = cmd.CreateParameter()
    param.ParameterName <- name
    param.Value <- value
    cmd.Parameters.Add(param) |> ignore
    f cmd
    
let nonQuery s (cmd: DbCommand) =
    cmd.CommandText <- s
    cmd.ExecuteNonQuery()

let read s (mapper: IDataRecord -> 'a) (cmd: DbCommand) =
    cmd.CommandText <- s
    use reader = cmd.ExecuteReader()
    [ while reader.Read() do yield mapper reader]

let map (mapper: IDataRecord -> 'i) (apply: (IDataRecord -> 'i) -> DbCommand -> 'i list) =
    apply (fun r -> mapper r)

type SqlLiteDb(cnxStr: string) =
    member _.execute (f: DbCommand -> 'a) =
        let c = new SQLiteConnection(cnxStr)
        c.Open()
        use cmd = c.CreateCommand()
        f cmd
```

Having the Sql module open, I can then write queries like this:

```fs
let insert (point: LatencyPoint) =
    nonQuery """
        INSERT INTO LatencyData (Time, Server, Latency)
        VALUES (@Time, @Server, @Latency);
    """
    |> withParam "Time" point.Time
    |> withParam "Server" config.Site
    |> withParam "Latency" (Option.toNullable point.Latency)
    |> db.execute
    |> ignore

lett selectFrom (from: DateTime) =
    read """
        SELECT 
            Time,
            Latency,
            (
                SELECT AVG(Latency)
                FROM LatencyData AS ld2
                WHERE ld2.Server = ld1.Server
                AND ld2.Time BETWEEN DATETIME(ld1.Time, '-5 minutes') AND ld1.Time
            ) AS Avg
        FROM LatencyData AS ld1
        WHERE Server = @Server AND Time >= @from
        ORDER BY Time DESC; """
    |> map (fun r -> {
        Time = r.GetDateTime(0)
        Latency = r.GetOption(1, _.GetInt32)
        Avg = r.GetFloat(2) })
    |> withParam "Server" config.Site
    |> withParam "from" from
    |> db.execute
```

I don't know about you, but this makes me smile. I don't understand why. I think this is art.
The intelectual satisfaction of making types fit together so that in the end I can have terse code that is readable is something i enjoy very much.

This is something AI will never do, and it might be at the same time both the biggest strength and weakness of the "biological computers" that are now used to build software.
AI will never be able to tell you if something is "beautiful". And sometimes, beautiful solutions are the best ones.

I think that part of what makes me a good software engineer is this love of beauty in code.
It might be sometimes a hindrance because we sometimes just need to get stuff done fast! I'm pragmatic enough to understand that, but usually this leads to "ugly" code. Hard to reason about. Tech debt. Subtle bugs.

Let's make code beautiful again!