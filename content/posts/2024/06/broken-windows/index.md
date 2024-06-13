---
title: "Broken Windows"
date: "2024-06-13"
categories:
  - "longs"
  - "original"
tags:
  - "dev"
---

> In criminology, the broken windows theory states that visible signs of crime, antisocial behavior and civil disorder create an urban environment that encourages further crime and disorder, including serious crimes. The theory suggests that policing methods that target minor crimes, such as vandalism, loitering, public drinking and fare evasion, help to create an atmosphere of order and lawfulness.
>
> – Broken windows theory - Wikipedia

Even though the theory is not proven in any scientific sense, I often think about it in relation of code “tidiness” and technical debt. I know by experience that if an “ugly” piece of code is in the code for long enough, the “ugliness” spreads, as patterns tend to be copied from existing code to new code.

If my living room is a mess because my kids were playing all day without supervision, I wont mind dropping some breadcrumbs from my cake. I’ll clean it later. On the other hand, if it is spotless, I will take extra care to keep it clean. In the same sense, if a codebase is a mess, I will take shortcuts and wont mind increasing the technical debt just a bit more (my code is not the bottleneck). On the other hand, if it’s patterns are clear and there is attention to detail, it’s easier to keep things organized.

It is a fact of life that entropy increases. Things tend to get naturally disorganized. It takes energy/effort/attention/intention to keep things “clean”. It takes even more effort to go from a mess to tidiness. It’s usually simpler to start anew. This is why the “big rewrite” approach is so appealing.

There is no top-down approach that can fix this problem. It is only solvable by giving individuals the tools and the incentives to do maintenance work without friction. It must be easy for an individual to fix each “broken window” that he finds. There needs to be incentives (or at least no deterrents) in place so that doing maintenance is rewarded.

What often happens is the opposite. “What if you break something?” or “That area is not our responsibility” or “Who will validate that change?” or “We don’t have the time for that” are often heard by the most zealous developers that try to “just do it”, and since there are no rewards, the technical debt just accumulates.

This is a gloomy outlook, but I want to leave you with a challenge:

- Managers! Empower your teams to do the right thing. Reward the maintainers. They are usually silent heroes that keep the building’s windows intact.
- Developers! [JUST DO IT](https://www.youtube.com/watch?v=ZXsQAXx_ao0). It might not be rewarded, it might not be easy, but it’s the right thing to do. Do it with confidence, and do it when you feel it is needed. Fix the broken windows.