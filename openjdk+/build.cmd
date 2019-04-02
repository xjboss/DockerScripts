@echo off
set IMAGE=xjboss/openjdk:stretch
docker build . -t %IMAGE%
rem docker run --rm -p 8081:8080 -p 50000:50000 -t -i xjboss/jenkinsplus
rem docker run --rm -t -i xjboss/jenkinsplus bash
rem docker run --rm -t -i %image%
docker push %IMAGE%