#!/usr/bin/env zsh
docker run -e POSTGRES_PASSWORD=password --name postgres -p 5432:5432 -d postgres
