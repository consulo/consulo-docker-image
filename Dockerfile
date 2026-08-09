FROM ubuntu:24.04

ARG TARGETARCH
ARG JDK_VERSION=25
ARG CONSULO_CHANNEL=nightly
ARG CONSULO_VERSION=SNAPSHOT

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/opt/jdk \
    CONSULO_HOME=/opt/consulo \
    PATH=/opt/jdk/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        nano \
        tar && \
    rm -rf /var/lib/apt/lists/*

RUN case "$TARGETARCH" in \
        amd64) JDK_ARCH=x64 ;; \
        arm64) JDK_ARCH=aarch64 ;; \
        *) echo "unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac && \
    mkdir -p /opt/jdk && \
    curl -fsSL "https://api.adoptium.net/v3/binary/latest/${JDK_VERSION}/ga/linux/${JDK_ARCH}/jdk/hotspot/normal/eclipse" \
        | tar -xz -C /opt/jdk --strip-components=1 && \
    java -version

RUN mkdir -p "$CONSULO_HOME" && \
    curl -fsSL "https://api.consulo.io/repository/download?id=consulo.dist.web&channel=${CONSULO_CHANNEL}&platformVersion=${CONSULO_VERSION}" \
        | tar -xz -C "$CONSULO_HOME" --strip-components=1

WORKDIR /opt/consulo

EXPOSE 8080

CMD ["./consulo.sh"]
