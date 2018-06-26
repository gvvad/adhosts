#!/bin/sh
HTTP_DAEMON="lighttpd"
BIND_IP="192.168.1.2"
FILE_URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
FULLPATH="$(pwd)/$0"
DIR="$(echo $FULLPATH | sed 's@\(.*\)/.*@\1@')"

# download and prepare hosts file
# and restart dnsmasq daemon
update() {
    rm hosts
    wget $FILE_URL --no-check-certificate -O hosts
    echo "parsing..."
    sed -i -e "/\slocalhost$/d;/[:#]/d;/^$/d;s/^[0-9.]*\s/$BIND_IP /" "$DIR/hosts"
    /etc/init.d/dnsmasq restart
}

# add ip addres to br-lan and start http server
start_http() {
    ip address add $BIND_IP dev br-lan
    sed -e "s@{www}@$DIR/www@;s@{pem}@$DIR/keyca.pem@;s@{ca}@$DIR/ca.crt@;s@{pidf}@$DIR/lighttpd.pid@;s@{ip}@$BIND_IP@" "$DIR/lighttpd.conf.pattern" > "$DIR/lighttpd.conf"
    $HTTP_DAEMON -f "$DIR/lighttpd.conf"&
}

# stop http server
stop_http() {
    if [ -f "$DIR/lighttpd.pid" ]
    then
        pid=$(cat "$DIR/lighttpd.pid")
        kill -9 $pid
        rm "$DIR/lighttpd.pid"
    fi
}

if [ "$1" = "update" ]
then
    update
fi

if [ "$1" = "start" ]
then
    stop_http
    start_http
    if [ ! -f "$DIR/hosts" ]
    then
        update
    fi
fi

if [ "$1" = "stop" ]
then
    stop_http
fi

if [ "$1" = "restart" ]
then
    stop_http
    start_http
fi
