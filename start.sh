#!/bin/sh

if [ -z "${READTHREADS}" ]; then
	READTHREADS=10
fi

if [ -z "${WRITETHREADS}" ]; then
	WRITETHREADS=10
fi

cat >/etc/collectd/collectd.conf <<-EOF
	Hostname "${HOSTNAME}"
	FQDNLookup false
	Interval 10
	Timeout 2
	ReadThreads ${READTHREADS}
	WriteThreads  ${WRITETHREADS}
	LoadPlugin cpu
	LoadPlugin disk
	LoadPlugin load
	LoadPlugin memory
	Include "/etc/collectd/collectd.d/*.conf"
EOF

for t in /etc/collectd/collectd.d/*.conf.sh; do
	cat >/etc/collectd/collectd.d/$(basename "${t}" ".sh") <"${t}"
done

exec collectd -C /etc/collectd/collectd.conf -f
