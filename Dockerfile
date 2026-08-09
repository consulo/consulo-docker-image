FROM ubuntu:24.04

ARG TARGETARCH
ARG JDK_VERSION=25

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/opt/jdk \
    PATH=/opt/jdk/bin:$PATH \
    CONSULO_DIR=/opt/consulo \
    CONSULO_DIST_ID=consulo.dist.web \
    CONSULO_CHANNEL=nightly \
    CONSULO_VERSION=SNAPSHOT

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

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /opt/consulo

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
