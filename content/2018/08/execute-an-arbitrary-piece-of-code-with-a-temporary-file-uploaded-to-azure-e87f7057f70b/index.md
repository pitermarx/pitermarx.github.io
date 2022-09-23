---
title: "Execute an arbitrary piece of code with a temporary file uploaded to azure"
date: "2018-08-06"
categories: 
  - "original"
  - "shorts"
tags: 
  - "dev"
---

A short one today.

My use case is to run a _Set-AzureRmVMCustomScriptExtension_ command. For it to work i need the script to be somewhere accessible by the VM.

Nothing to fancy. Might be useful for someone (or a future version of me). It creates a temp container, uploads the file, invokes the code passing in the URI, and whatever happens the container will be deleted. Assumes a connection to azure and an already existing storage account.

Just to highlight an interesting point

> “temp-container-” + (-join ((97..122) | Get-Random -Count 5 | % {\[char\]$\_}))

Initially i just had “temp-container” but when running 2 times in a row I got an error saying that the container could not be created as it was being deleted. So [I found a way](https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/05/generate-random-letters-with-powershell/) to generate random letters and now it creates an “unique” container each time.
