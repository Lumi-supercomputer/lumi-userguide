---
title: Computing - Overview
---

[modules]: ./modules.md
[jobsub]: ./jobs/submitting-jobs.md
[interactive]: ./jobs/interactive.md
[lumic]: ./systems/lumic.md
[lumig]: ./systems/lumig.md

# Overview

## Connecting

## Learn More About the LUMI Hardware
 
- Learn more about LUMI-C: [the CPU partition][lumic]
- Learn more about LUMI-G: [the GPU partition][lumig]

## Setup your Environment

Softwares on LUMI can be accessed through [modules][modules]. With the help module
command you will be able to load and unload the desired compilers, tools
and libraries.

## Running your Jobs

The basic step to run your application on LUMI can be sumarized as follow:

- Determine the resources needed for your job
- Pick a partition (queue) that will provide the required resources
- Create a job script that describes the resources needed for your job and the
  the steps needed to run your application
