FROM gliderlabs/alpine:3.1
MAINTAINER Tom Hite <thite@vmware.com>
ADD start.sh /start.sh
ADD collectd.d /etc/collectd/collectd.d
RUN apk-install collectd && chmod +x /start.sh
CMD /start.sh
