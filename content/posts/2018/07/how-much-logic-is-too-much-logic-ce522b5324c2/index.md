---
title: "How much logic is too much logic?"
date: "2018-07-10"
categories: 
  - "longs"
  - "original"
tags: 
  - "dev"
---

Today there was a small argument about constructors and how slim should they be.

In this post I will attempt to explain my position on it.

On a general note, we all agree that constructors should not do much. Nevertheless I affirm that it is acceptable and even useful in some cases, to have logic in them, given that some rules are respected.

In the remainder of this post I will refer to the logic in the constructors as simply “logic” but this can be:

- Straightforward operations
- Complex logic, or even
- IO access

The main contention point is that constructors should not have operations that may throw. First I will review the arguments against it, and then give some arguments for it.

There were 4 lines of argument against having “logic” inside a constructor body

1. Hard to trace exceptions/memory leaks
2. Single responsibility
3. Principle of least astonishment ([POLA](https://en.wikipedia.org/wiki/Principle_of_least_astonishment))
4. Dependency injection for decoupling/testing purposes

#### On the point one, this is simply not true in most cases

The hard to trace exceptions only exist in cases that you don’t instantiate the class yourself and don’t have logging in place to see the stack trace. It’s really not applicable

The memory leaks traces back to c++ that can allocate memory for an object and never free it if there is an unhandled exception. In .net this is not applicable either because the language is garbage collected.

If there is no destructor and no object that needs to be disposed, this is no reason for not having logic in the constructor

#### On the point two, the single responsibility is arguable

This is a reasonable principle, the contention point being what is the responsibility of the constructor.

If the constructor is doing side effects or mutating other objects, this is clearly bad but if the “logic” is about getting the object into a valid state i would argue that it is valid logic to be inside the constructor

#### On the third point, POLA, let’s see what could be astonishing

If you give an object a set of invalid parameters, should you be astonished that it throws an exception?

If you give an object an connectionstring, should you be astonished that it goes to the database?

If the object cannot get into a valid state, should you be astonished that it cannot be instantiated?

It is a good principle, but i don’t think any of the above cases is astonishing

#### On the fourth point, inversion of control, I agree on all cases

If you want your object to be testable, it should not instantiate any other object directly unless the two objects should only be tested together

If you want your object to be testable, it should use any static member directly

If you violate these principles, unit testing is impossible. Your tests will include more than your object

My main argument is that i believe that a constructor should only allow an object to get into a valid state. I believe that this is reasonable and is not on contention.

The constructor’s job is to bring the object into a usable state. There are basically two ways you can do this:

1. Two-stage construction. The constructor merely brings the object into a state in which it refuses to do any work. There’s an additional function that does the actual initialization.
2. One-stage construction, where the object is fully initialized and usable after construction.

I don’t think the two stage method is a good approach. Every method should enforce that it is not ran if the object is not valid, and there is a good chance the _Init_ method wont be called if the class is to be reused by many people

I’m in favour of the one-stage construction.

There is also two ways you can do this, if you want to keep your code [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

1. Have a method somewhere that has your initialization logic

The best place in my opinion is a static _Create_ method along side the constructor

2\. Have your logic inside the constructor

I have used both approaches and believe that both are valid. I don’t have a strong opinion about which one should be used.

What do you think?
