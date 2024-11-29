FROM alpine:3.20.3

RUN set -ex; \
        apk --no-cache --update --upgrade add curl tor \
        # && mkdir /etc/torrc.d \
        && echo 'SOCKSPort 0.0.0.0:9050' >>/etc/tor/torrc \
        && echo 'Log notice stderr' >>/etc/tor/torrc \
        && echo 'DataDirectory /var/lib/tor' >>/etc/tor/torrc \
        && echo 'ControlPort 9051' >>/etc/tor/torrc \
        && echo 'RunAsDaemon 0' >>/etc/tor/torrc \
        # && echo '%include /etc/torrc.d/*.conf' >>/etc/tor/torrc \
        && chown -R tor /var/lib/tor

USER tor
EXPOSE 9050 9051

HEALTHCHECK --interval=300s --timeout=10s --start-period=300s --retries=3 CMD curl -s --socks5 localhost:9050 https://check.torproject.org/ | grep -i "congratulations"

CMD [ "/usr/bin/tor" ]
