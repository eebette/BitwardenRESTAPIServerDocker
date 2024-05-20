FROM debian:sid

RUN apt update && \
    apt install -y wget unzip && \
    wget --content-disposition --cut-dirs 100 -r -l 1 --span-hosts --accept-regex='.*vault.bitwarden.com\/.*.zip' -erobots=off -nH https://vault.bitwarden.com/download/\?app=cli\&platform=linux && \
    unzip bw-linux-*.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    rm -rfv *.zip

COPY entrypoint.sh /
COPY login.sh /

# Grant execution permissions to the entrypoint script
RUN chmod +x /entrypoint.sh
RUN chmod +x /login.sh

CMD ["/entrypoint.sh"]
