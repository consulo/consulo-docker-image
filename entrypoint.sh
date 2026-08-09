#!/bin/sh
set -e

if [ ! -x "$CONSULO_DIR/Consulo/consulo.sh" ]; then
    echo "Downloading Consulo ($CONSULO_DIST_ID, channel $CONSULO_CHANNEL, version $CONSULO_VERSION)"
    mkdir -p "$CONSULO_DIR"
    curl -fsSL "https://api.consulo.io/repository/download?id=${CONSULO_DIST_ID}&channel=${CONSULO_CHANNEL}&platformVersion=${CONSULO_VERSION}" \
        | tar -xz -C "$CONSULO_DIR"
fi

cd "$CONSULO_DIR/Consulo"
exec ./consulo.sh "$@"
