FROM ruby:2.4.2
MAINTAINER Pema Geyleg <pema@casecommons.org>

RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y \
    build-essential \
    iceweasel \
    chromium \
    xvfb \
    jq \
    curl \
    python-dev \
    python-setuptools && \
  easy_install pip && \
  pip install awscli && \
  curl -L -o /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 && \
  chmod +x /usr/bin/confd && \
  mkdir -p /etc/confd

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

COPY src/entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]

LABEL application=intake_accelerator
