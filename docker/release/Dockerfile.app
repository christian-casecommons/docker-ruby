FROM ruby:2.4.0-slim
MAINTAINER Pema Geyleg <pema@casecommons.org>

RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y \
    jq \
    curl \
    python-dev \
    python-setuptools && \
  easy_install pip && \
  pip install awscli && \
  curl -L -o /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 && \
  chmod +x /usr/bin/confd && \
  mkdir -p /etc/confd

HEALTHCHECK --interval=3s --retries=20 CMD ${HEALTHCHECK:-curl -fs localhost:${HTTP_PORT:-3002}}

RUN gem install rack

COPY config.ru /config.ru
CMD ["rackup","-p","3002","/config.ru"]