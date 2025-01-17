FROM debian:12-slim

# RUN set -ex; \
#     apk --no-cache --update --upgrade add curl tor \
RUN set -ex; \
    apt-get update && apt-get install -y tor curl \
    && sed -i 's/#SocksPort 9050/SocksPort 0.0.0.0:9050/' /etc/tor/torrc \
    && sed -i 's/#Log debug stderr/Log notice stderr/' /etc/tor/torrc \
    && sed -i 's/#DataDirectory/DataDirectory/' /etc/tor/torrc \
    # && sed -i '/#ControlPort 9051/ControlPort 9051/' /etc/tor/torrc \
    # && sed -i '/#RunAsDaemon 1/RunAsDaemon 0/' /etc/tor/torrc \
    && useradd -ms /bin/bash tor \
    && chown -R tor /var/lib/tor

USER tor
EXPOSE 9050
# 9051
VOLUME /var/lib/tor

HEALTHCHECK --interval=3600s --timeout=10s --start-period=300s --retries=3 CMD curl -s --socks5 localhost:9050 https://check.torproject.org/ | grep -i "congratulations"

CMD [ "/usr/bin/tor" ]
