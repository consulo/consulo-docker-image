FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/opt/tools/jdk \
    PATH=/opt/tools/jdk/bin:/opt/tools/nodejs/bin:/opt/tools/go/bin:/root/go/bin:/opt/tools/dotnet:/opt/tools/rust/cargo/bin:$PATH \
    TOOL_JAVA_VERSION=25 \
    CONSULO_DIR=/opt/consulo \
    CONSULO_WEB_PORT=8080 \
    CONSULO_DIST_ID=consulo.dist.web \
    CONSULO_CHANNEL=nightly \
    CONSULO_VERSION=SNAPSHOT \
    TOOLS_DIR=/opt/tools \
    NODEJS_HOME=/opt/tools/nodejs \
    GOROOT=/opt/tools/go \
    GOPATH=/root/go \
    DOTNET_ROOT=/opt/tools/dotnet \
    RUSTUP_HOME=/opt/tools/rust/rustup \
    CARGO_HOME=/opt/tools/rust/cargo \
    TOOL_NODEJS=1 \
    TOOL_NODEJS_VERSION=24.19.0 \
    TOOL_GO=1 \
    TOOL_GO_VERSION=1.26.5 \
    TOOL_RUST=1 \
    TOOL_RUST_VERSION=stable \
    TOOL_DOTNET=1 \
    TOOL_DOTNET_VERSION=LTS

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libicu74 \
        nano \
        tar \
        xz-utils && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /opt/consulo
VOLUME /opt/tools

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
