FROM docker.io/python:slim

RUN apt-get update && apt-get install -y git
RUN pip install --upgrade pip && pip install ansible ansible-lint
