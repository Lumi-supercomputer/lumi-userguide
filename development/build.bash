#!/usr/bin/env bash

build_cmd() {
    podman build --format docker "$@"
}

build_builder() {
    build_cmd --file Containerfile.builder \
              --build-arg-file development/argfile.builder.conf \
              --tag lumi-docs-builder \
      ./
}

build_image() {
    build_cmd --file Containerfile \
              --build-arg-file development/argfile.conf \
              --tag lumi-docs \
      ./
}

build_builder && build_image
