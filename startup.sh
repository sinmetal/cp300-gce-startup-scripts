#! /bin/bash
#
# Copyright 2015 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ZONE_ENDPOINT=TODO
HOSTNAME_ENDPOINT=TODO
IPADDRESS_ENDPOINT='http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip'

ZONE_VALUE=$(curl "$ZONE_ENDPOINT" -H "Metadata-Flavor: Google")
HOSTNAME_VALUE=$(curl "$HOSTNAME_ENDPOINT" -H "Metadata-Flavor: Google")
IPADDRESS=$(curl "$IPADDRESS_ENDPOINT" -H "Metadata-Flavor: Google")

# awk is being used here to select a substring of the value 
# returned by the metadata server
ZONE=$(echo $ZONE_VALUE | awk -F "/" '{print $4}')
HOSTNAME=$(echo $HOSTNAME_VALUE | awk -F "." '{print $1}')

DATE=$(date)

apt-get update
apt-get install -y nginx

cat <<EOF > /var/www/html/index.nginx-debian.html
<html>
<head>
<title>Welcome to nginx!</title>
</head>
<body bgcolor="white" text="black">
<center><h1>Welcome to nginx on Compute Engine!</h1></center>
<center><h2>This is '$HOSTNAME'!</h2></center>
<center><p>Running in zone '$ZONE', with IP address $IPADDRESS</p></center>
<center><p>This page was created on $DATE</p></center>
</body>
</html>
EOF
/etc/init.d/nginx restart
