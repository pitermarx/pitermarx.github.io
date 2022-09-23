---
title: "Developer evolution"
date: "2018-01-12"
categories: 
  - "longs"
  - "original"
tags: 
  - "dev"
---

One of the great things of staying on the same job – and on the same project – for a long time is that once in a while you get to see code you wrote years ago. Yesterday was one of those days. I had the opportunity to see how much my coding skills had evolved.

I was confronted with a performance issue from a piece of code I wrote 5 years ago. After a couple of hours I and a colleague pinpointed the bottleneck and rewrote the problematic code. The code ran 6–8x faster.

I want to make 3 points from this:

- Don’t optimize prematurely. The code was in production for 5 years and was good enough. In that time I could improve my understanding of the whole system, a crucial skill to make good design decisions.
- Challenge yourself. The bottleneck was quite obvious once I saw it. 5 years ago I didn’t have the maturity to question my own code. This could have been avoided with tools like pair programming or code reviews but it’s always a good thing to take a critical look at your work before checking in
- Measure. Sometimes the problematic code is not that obvious. There are great tools that help you to measure the performance of your code. Learn to use them.

I want to thank the developer – or team – behind [CodeTrack](http://www.getcodetrack.com/). It’s a great tool and on top of that completely free! If you work in .net it’s a must have.
