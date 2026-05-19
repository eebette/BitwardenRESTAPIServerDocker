FROM debian:sid

# Pinned to v2026.1.0 — v2026.3.0 / v2026.4.1 ship a regression where bw
# unlock --raw returns a session token but the vault state isn't propagated to
# the Node CLI's in-memory state, so all subsequent commands (`bw status`,
# `bw get`, `bw list`) report locked and fall back to the interactive master
# password prompt. The bug only triggers once the account is enrolled in the
# masterPasswordUnlockData feature server-side, which is why a previously
# working image breaks without any client change. See
# https://github.com/bitwarden/clients/issues/20703. Revisit when the upstream
# fix lands and a known-good 2026.x release is published.
ARG BW_CLI_VERSION=2026.1.0
RUN apt update && \
    apt install -y unzip curl jq procps && \
    curl -fLo bw-linux.zip "https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-linux-${BW_CLI_VERSION}.zip" && \
    unzip bw-linux.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    rm -rfv *.zip && \
    [ "$(bw --version)" = "${BW_CLI_VERSION}" ] || { echo "bw version mismatch: got $(bw --version), wanted ${BW_CLI_VERSION}"; exit 1; }

COPY entrypoint.sh /

# Grant execution permissions to the entrypoint script
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
