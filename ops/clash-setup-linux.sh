#!/bin/bash
####################################################################
## Clash proxy service
## Update: 2022/02/07
## Create: yijie
## Matainer: yijie
## Adatper Device: amd64 Linux
####################################################################
####################################################################
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# `under the License
####################################################################

# You can setup new version by first variable, the default calsh version is v1.9.0
CLASHVERSION=${1:-v1.9.0}
APP_NAME=clash-linux-amd64-${CLASHVERSION}
WORKSPACE=clash-proxy-service-${CLASHVERSION}
TIMESTAMP=$(date +"%s")
if pidof -x ${APP_NAME} > /dev/null; then
    echo " ==================================================>> The clash is Running already!  "
    exit
fi
echo " ==================================================>> Setup clash ${CLASHVERSION} as proxy server with name ${APP_NAME} at location: ${WORKSPACE}"
wget  https://github.91chi.fun//https://github.com//Dreamacro/clash/releases/download/${CLASHVERSION}/${APP_NAME}.gz -O ${APP_NAME}.gz
gzip -dk ${APP_NAME}.gz
chmod +x ${APP_NAME}
mkdir -p ${WORKSPACE} 
cd ${WORKSPACE}
mv ../${APP_NAME} .

if [ -z ${2+x} ]; then 
    printf " ==================================================>> Please select the configuration sets \e[44;33;1m (ip1, ip2, ip3, ip4, ip5, ip6) \e[0m...?"
    read CONFIG_CASE
else
    CONFIG_CASE=${2:-1}
fi
case $CONFIG_CASE in 
     ip1)
          wget --no-check-certificate https://gitlab.com/free9999/ipupdate/-/raw/master/clash/config.yaml -O config.yaml
           ;;
     ip2)
           wget --no-check-certificate https://cdn.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/config.yaml -O config.yaml
           ;;
     ip3)
           wget --no-check-certificate https://gitlab.com/free9999/ipupdate/-/raw/master/clash/2/config.yaml -O config.yaml
           ;;
     ip4)
           wget -check-certificate https://gitlab.com/free9999/ipupdate/-/raw/master/clash/3/config.yaml -O config.yaml
	   ;;
     ip5)
           wget --no-check-certificate https://cdn.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/2/config.yaml -O config.yaml
           ;;
     ip6)
	   wget --no-check-certificate https://cdn.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/3/config.yaml
	   ;;
     *)
          wget --no-check-certificate https://gitlab.com/free9999/ipupdate/-/raw/master/clash/config.yaml -O config.yaml
           ;;     
esac
screen -dmS ClasshProxy-${CLASHVERSION}-${TIMESTAMP} ./${APP_NAME} -d .
# Retarch session
## screen ls
## screen -r clashProxy

percentBar () { 
    local prct totlen=$((8*$2)) lastchar barstring blankstring;
    printf -v prct %.2f "$1"
    ((prct=10#${prct/.}*totlen/10000, prct%8)) &&
        printf -v lastchar '\\U258%X' $(( 16 - prct%8 )) ||
            lastchar=''
    printf -v barstring '%*s' $((prct/8)) ''
    printf -v barstring '%b' "${barstring// /\\U2588}$lastchar"
    printf -v blankstring '%*s' $(((totlen-prct)/8)) ''
    printf -v "$3" '%s%s' "$barstring" "$blankstring"
}
		    
for i in {0..10000..10} 10000;do i=0$i
    printf -v p %0.2f ${i::-2}.${i: -2}
    percentBar $p $((COLUMNS-9)) bar
    printf '\r|%s|%6.2f%%' "$bar" $p
    read -srt .002 _ && break    # console sleep avoiding fork
done    
		    
echo """
 ==================================================>> Clash proxy is Running...
  The HTTP/S proxy is: 127.0.0.1:7890
  The socks5 proxy is: 127.0.0.1:7891i=1
"""


