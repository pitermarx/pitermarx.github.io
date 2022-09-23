---
title: "Powershell closures"
date: "2018-08-07"
categories: 
  - "original"
  - "shorts"
tags: 
  - "dev"
---

As a [follow up to the previous article](https://blog.pitermarx.com/2018/08/execute-an-arbitrary-piece-of-code-with-a-temporary-file-uploaded-to-azure-e87f7057f70b/), I needed to warn you (and me) about powershell closures. They didn’t work as i expected

```
$Foo = 1
Write-Host "I expect Foo to be 1: " $Foo

function New-Closure {
    param([Scriptblock] $Expression, $Foo = 2) 
    & $Expression
}

New-Closure -Expression {
    Write-Host "I expected Foo to be 1, but was 2: " $Foo
}

New-Closure -Expression {
    Write-Host "I expected Foo to be 1, and it is: " $Foo
}.GetNewClosure()
```

The confusion point for me was that $Foo can be changed by the invoker, unless we add the .GetNewClosure().

As in the previous article the parameter name $ResourceGroupName is very common, it’s best to always use the .GetNewClosure() on the ScriptBlock
