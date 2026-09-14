FROM node:24-bookworm-slim

ARG FEYNMAN_VERSION=latest

LABEL org.opencontainers.image.title="Feynman for Unraid" \
      org.opencontainers.image.description="Unofficial Docker packaging of the Feynman open-source AI research agent for Unraid" \
      org.opencontainers.image.source="https://github.com/Denisb508/unraid-feynman" \
      org.opencontainers.image.url="https://github.com/Denisb508/unraid-feynman" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.vendor="Denisb508"

ENV DEBIAN_FRONTEND=noninteractive \
    FEYNMAN_PORT=8787 \
    FEYNMAN_WORKSPACE=/workspace \
    FEYNMAN_NO_AUTH=true \
    FEYNMAN_HOME=/config \
    TZ=Etc/UTC

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash \
       ca-certificates \
       curl \
       git \
       openssh-client \
       python3 \
       python3-pip \
       python3-venv \
       tini \
    && rm -rf /var/lib/apt/lists/* \
    && npm install --global "@advaitpaliwal/feynman@${FEYNMAN_VERSION}" \
    && npm cache clean --force

COPY docker/entrypoint.sh /usr/local/bin/feynman-unraid-entrypoint
RUN chmod 0755 /usr/local/bin/feynman-unraid-entrypoint \
    && mkdir -p /config /workspace

WORKDIR /workspace

VOLUME ["/config", "/workspace"]
EXPOSE 8787

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD-SHELL node -e "fetch('http://127.0.0.1:'+(process.env.FEYNMAN_PORT||'8787')+'/api/health').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/feynman-unraid-entrypoint"]
CMD []
