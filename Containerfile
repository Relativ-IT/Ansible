FROM docker.io/python:slim

ENV PIP_ROOT_USER_ACTION=ignore

RUN useradd -m ansible && apt-get update && apt-get install -y git && apt-get clean
RUN pip install --upgrade pip && pip install ansible ansible-lint

USER ansible