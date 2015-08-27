#!/bin/sh
#
#  Copyright 2015 VMware, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

# When using ansible to build and run docker - we do not use this start.sh as this script is used to populate the config template, push it to 
# the config directory on remote target and then start collectd. 

# We now have a config template that is used by ansible or jenkins to create the config file. The run.sh is used to
# start collectd

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
