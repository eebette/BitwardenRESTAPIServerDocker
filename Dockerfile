FROM debian:sid

# RUN apt update && \
#     apt install -y wget unzip curl jq procps && \
#     wget --content-disposition --cut-dirs 100 -r -l 1 --span-hosts --accept-regex='.*vault\.bitwarden\.com\/.*.zip' -erobots=off -nH https://vault.bitwarden.com/download/\?app=cli\&platform=linux && \
#     unzip bw-linux-*.zip && \
#     chmod +x bw && \
#     mv bw /usr/local/bin/bw && \
#     rm -rfv *.zip

RUN apt update && \
    apt install -y wget unzip curl jq procps && \
    wget --content-disposition --cut-dirs 100 -r -l 1 --span-hosts --accept-regex='.*vault\.bitwarden\.com\/.*2024\.6\.0.*.zip' -erobots=off -nH https://github.com/bitwarden/clients/releases/download/cli-v2024.6.0/bw-linux-2024.6.0.zip  && \
    unzip bw-linux-*.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    rm -rfv *.zip

COPY entrypoint.sh /

# Grant execution permissions to the entrypoint script
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
