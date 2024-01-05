FROM mcr.microsoft.com/devcontainers/base:jammy

RUN curl -L https://github.com/hetznercloud/cli/releases/latest/download/hcloud-linux-amd64.tar.gz --output /tmp/hcloud.tar.gz \
  && tar -xf /tmp/hcloud.tar.gz -C /tmp \
  && mv /tmp/hcloud /usr/local/bin/hcloud \
  && rm -Rf /tmp/*

RUN apt-get update && \
  apt-get install -y apt-transport-https ca-certificates curl gnupg && \
  install -m 0755 -d /etc/apt/keyrings && \
  curl -fsSL https://get.opentofu.org/opentofu.gpg > /etc/apt/keyrings/opentofu.gpg && \
  curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null && \
  chmod a+r /etc/apt/keyrings/opentofu.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" > /etc/apt/sources.list.d/opentofu.list && \
  echo "deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" >> /etc/apt/sources.list.d/opentofu.list && \
  apt-get update && \
  apt-get install -y tofu && \
  ln -s /usr/bin/tofu /usr/bin/terraform