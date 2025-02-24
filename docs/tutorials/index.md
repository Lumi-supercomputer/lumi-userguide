# Overview

[training-material]: https://lumi-supercomputer.github.io/LUMI-training-materials/
[coffee-breaks]: https://lumi-supercomputer.github.io/LUMI-training-materials/User-Coffee-Breaks/
[user-updates]: https://lumi-supercomputer.github.io/LUMI-training-materials/User-Updates/
[ai-guide]: https://github.com/Lumi-supercomputer/LUMI-AI-Guide
[VisionTransformer]: https://pytorch.org/vision/main/models/vision_transformer.html
[imagenet]: https://www.image-net.org/
[vt-script]: https://github.com/Lumi-supercomputer/LUMI-AI-Guide/blob/main/quickstart/visualtransformer.py

## Training Material

The LUMI training material is hosted at [lumi-supercomputer.github.io/LUMI-training-materials][training-material].

It contains all slides and recordings of all past LUMI training events, including introductory and advanced courses, AI workshops, hackathons, and profiling courses. The training material also provides recordings of the [LUMI user coffee break talks][coffee-breaks] and [user update events][user-updates].

## LUMI AI Guide

The LUMI AI Guide is hosted at [github.com/Lumi-supercomputer/LUMI-AI-Guide][ai-guide].

This guide is designed to assist users in migrating their machine learning applications from smaller-scale computing environments to LUMI. We will walk you through a detailed example of training an image classification model using PyTorch's [Vision Transformer (VIT)][VisionTransformer] on the [ImageNet][imagenet] dataset.

All Python and Bash scripts referenced in this guide are accessible in the [GitHub repository][ai-guide]. We start with a basic Python script, [visualtransformer.py][vt-script], that could run on your local machine and modify it over the next chapters to run it efficiently on LUMI.

Even though this guide uses PyTorch, most of the covered topics are independent of the used machine learning framework. We therefore believe this guide is helpful for all new ML users on LUMI while also providing a concrete example that runs on LUMI.

