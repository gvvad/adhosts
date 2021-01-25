#!/bin/sh
HTTP_DAEMON="lighttpd"
DAEMON_CMD="lighttpd -f"
BIND_IP="192.168.1.2"
FILE_URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
HOSTS_FILE="hosts"
EXCLUDE_FILE="exclude"

my_dir="$(dirname "$0")"
cd "$my_dir"
DIR="$(pwd)"

# download and prepare hosts file
# and restart dnsmasq daemon
update() {
    rm "$HOSTS_FILE"
    wget $FILE_URL --no-check-certificate -O "$HOSTS_FILE"
    if [ -f "$EXCLUDE_FILE" ]
    then
        echo "Excluding:"
        while IFS= read -r line
        do
            echo "$line"
            sed -E -i "/$line/d" "$HOSTS_FILE"
        done < "exclude"
    fi
    
    echo "Preparing..."
    sed -i -e "s/^[0-9.]*\s/$BIND_IP /" "$HOSTS_FILE"
    /etc/init.d/dnsmasq restart
}

# add ip addres to br-lan and start http server
start_http() {
    ip address add $BIND_IP dev br-lan
    sed -e "s@{www}@$DIR/www@;s@{key}@$DIR/key.pem@;s@{ca}@$DIR/ca.crt@;s@{keyca}@$DIR/keyca.pem@;s@{pidf}@$DIR/$HTTP_DAEMON.pid@;s@{ip}@$BIND_IP@" "$DIR/$HTTP_DAEMON.conf.pattern" > "$DIR/$HTTP_DAEMON.conf"
    $DAEMON_CMD "$DIR/$HTTP_DAEMON.conf"
}

# stop http server
stop_http() {
    if [ -f "$DIR/$HTTP_DAEMON.pid" ]
    then
        pid=$(cat "$DIR/$HTTP_DAEMON.pid")
        kill -2 $pid
        rm "$DIR/$HTTP_DAEMON.pid"
    else
        echo "PID file $DIR/$HTTP_DAEMON.pid not found! Server was not stopped."
    fi
}

if [ "$1" = "update" ]
then
    update
fi

if [ "$1" = "start" ]
then
    start_http
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
