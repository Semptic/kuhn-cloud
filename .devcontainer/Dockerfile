FROM mcr.microsoft.com/devcontainers/base:jammy

RUN curl -L https://github.com/hetznercloud/cli/releases/latest/download/hcloud-linux-amd64.tar.gz --output /tmp/hcloud.tar.gz \
  && tar -xf /tmp/hcloud.tar.gz -C /tmp \
  && mv /tmp/hcloud /usr/local/bin/hcloud \
  && rm -Rf /tmp/*