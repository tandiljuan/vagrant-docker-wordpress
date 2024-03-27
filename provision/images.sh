#!/bin/bash

# Download images
docker image pull debian:bookworm-slim
docker image pull ubuntu:jammy
docker image pull mariadb:10.11
docker image pull redis:7.2-bookworm
docker image pull dunglas/frankenphp:1.1.1-php8.2-bookworm
