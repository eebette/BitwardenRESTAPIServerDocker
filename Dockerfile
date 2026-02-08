FROM debian:sid

RUN apt update && \
    apt install -y unzip curl jq procps && \
    curl -Lo bw-linux.zip "https://vault.bitwarden.com/download/?app=cli&platform=linux" && \
    unzip bw-linux.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    rm -rfv *.zip

COPY entrypoint.sh /

# Grant execution permissions to the entrypoint script
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
