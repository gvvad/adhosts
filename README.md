# AdHosts for OpenWrt
Block malware and not "friendly" sites on your local network.
### Depend on:
* [lighttpd](https://openwrt.org/packages/pkgdata/lighttpd)

### Using:

`sh ./adhosts.sh update` - update hosts file

`sh ./adhosts.sh start` - start http server

* Add addition hosts file to config: `/etc/config/dhcp` => [`config dnsmasq`]
    * `list addnhosts '/path/to/adhosts/hosts'`
* Set execute flags
    * `chmod 777 ./adhosts.sh`
* Set [cron](https://wiki.openwrt.org/doc/howto/cron) task
    * `* * * */1 * sh /path/to/adhosts/adhosts.sh update`
* Set startup [(/etc/rc.local)](https://wiki.openwrt.org/doc/techref/process.boot) task:
    * `sh /path/to/adhosts/adhosts.sh start`

### Hosts files:
[StevenBlack/hosts](https://github.com/StevenBlack/hosts)
