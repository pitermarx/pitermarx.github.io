---
title: "FSharp Computation Expressions"
date: "2025-09-18"
categories:
  - "longs"
  - "original"
tags:
  - "dev"
---

![](game.png)

Last year on my birthday I received a cool gift. A puzzle where 19 numbers (1 to 19) need to be arranged in an hexagon, so that all "lines" add up to 38.

I couldn't solve it. It's too hard for me. But as a programmer, I can build a program that solves it!

I started typing and the AI code completion agent did most of the work, using a (mostly) brute force algorithm.
It solved the puzzle, but took too long. I wasn't happy with it. I optimized it by modeling the solution after the "real" way I would solve it if I wasn't so lazy.

In my model I have a "bag" with the numbers, and I take them one by one at random or the correct one if I know what it is. If the correct one is not in the bag then I know this solution is impossible and I have to backtrace to try another combination. It worked but the code was UGLY! A pyramid of doom callbacks!

Then I remembered about F# computation expressions and how they would probably be a perfect fit for this. I never developed CE before, so I tried to have the LLM do it for me.
I mean I had read about them before, and tried to play with it, but it never clicked for me. The results were terrible. I couldn't find an AI model that can deal well with CE.

Back to "hand coding" and reading the docs!
I found a great set of posts about it.
https://fsharpforfunandprofit.com/posts/computation-expressions-intro/

I love the result. Here it is

```fs
printfn @"ALL NUMBERS ARE DIFFERENT AND BETWEEN 1 AND 19
N00+N01+N02 = 38                N00
N02+N03+N04 = 38            N11     N01
N04+N05+N06 = 38        N10     N12     N02
N06+N07+N08 = 38            N17     N13
N08+N09+N10 = 38        N09     N18     N03
N10+N11+N00 = 38            N16     N14
N11+N12+N13+N03 = 38    N08     N15     N04
N01+N13+N14+N05 = 38        N07     N05
N03+N14+N15+N07 = 38            N06
N05+N15+N16+N09 = 38
N07+N16+N17+N11 = 38
N09+N17+N12+N01 = 38
N00+N12+N18+N15+N06 = N02+N13+N18+N16+N08 = N04+N14+N18+N17+N10 = 38"

type BagBuilder(seq: int list) =
    let bag = System.Collections.Generic.HashSet<int>(seq)
 
    member this.Bind(x, f) =
        match x with
        | None -> ()
        | Some x -> f x
 
    member this.For(sequence: seq<int>, body: int-> unit) : unit =
        for i in seq do
            match this.Take(i) with
            | None -> ()
            | Some i -> this.Using(i, body)
 
    member this.Using(item: int, body: int -> unit) : unit =
        body item
        bag.Add(item) |> ignore
 
    member this.Zero(x) = ()
 
    member this.Take(x: int) : int option =
        if bag.Contains(x) then
            bag.Remove(x) |> ignore
            Some x
        else
            None
 
printfn "Searching for solutions..."
let bag = BagBuilder([1..19])
 
let mutable solutions = []
bag {
    for n1 in [1..19] do
    for n2 in [1..19] do
    use! n3 = bag.Take(38 - n1 - n2)
    for n4 in [1..19] do
    use! n5 = bag.Take(38 - n3 - n4)
    for n6 in [1..19] do
    use! n7 = bag.Take(38 - n5 - n6)
    for n8 in [1..19] do
    use! n9 = bag.Take(38 - n7 - n8)
    for n10 in [1..19] do
    use! n11 = bag.Take(38 - n9 - n10)
    use! n12 = bag.Take(38 - n11 - n1)
    for n13 in [1..19] do
    use! n14 = bag.Take(38 - n12 - n4 - n13)
    use! n15 = bag.Take(38 - n2 - n14 - n6)
    use! n16 = bag.Take(38 - n4 - n15 - n8)
    use! n17 = bag.Take(38 - n6 - n16 - n10)
    use! n18 = bag.Take(38 - n8 - n17 - n12)
    use! n19 = bag.Take(38 - n15 - n5 - n18 - n11)
    solutions <- [|n1; n2; n3; n4; n5; n6; n7; n8; n9; n10; n11; n12; n13; n14; n15; n16; n17; n18; n19|] :: solutions
}
 
solutions
|> List.chunkBySize 2
|> List.iter (fun (solutions: int array list) ->
    let render (s: int array) =
        [|
            (sprintf "        %02d          |" s.[0]);
            (sprintf "    %02d      %02d      |" s.[11] s.[1]);
            (sprintf "%02d      %02d      %02d  |" s.[10] s.[12] s.[2]);
            (sprintf "    %02d      %02d      |" s.[17] s.[13]);
            (sprintf "%02d      %02d      %02d  |" s.[9]  s.[18] s.[3]);
            (sprintf "    %02d      %02d      |" s.[16] s.[14]);
            (sprintf "%02d      %02d      %02d  |" s.[8]  s.[15] s.[4]);
            (sprintf "    %02d      %02d      |" s.[7]  s.[5]);
            (sprintf "        %02d          |" s.[6]);
        |]
    let visualizations = solutions |> List.map render
    for i in 0 .. 8 do
        printfn "|  %s" (visualizations |> List.map (fun viz -> viz.[i]) |> String.concat "   "))
```

Let me quote myself from a year ago, as the same is applicable today:

> I don't know about you, but this makes me smile. I don't understand why. I think this is art.
> The intelectual satisfaction of making types fit together so that in the end I can have terse code that is readable is something i enjoy very much.
>
> This is something AI will never do, and it might be at the same time both the biggest strength and weakness of the "biological computers" that are now used to build software.
> AI will never be able to tell you if something is "beautiful". And sometimes, beautiful solutions are the best ones.
>
> I think that part of what makes me a good software engineer is this love of beauty in code.
> It might be sometimes a hindrance because we sometimes just need to get stuff done fast! I'm pragmatic enough to understand that, but usually this leads to "ugly" code. Hard to reason about. Tech debt. Subtle bugs.
>
> Let's make code beautiful again!