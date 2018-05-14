# AdHosts for OpenWrt
Block malware and not "friendly" sites on your local network.
### Depend on:
* [lighttpd](https://openwrt.org/packages/pkgdata/lighttpd)

### Using:

`update` - update hosts file

`start` - start http server

* Add addition hosts file `/etc/config/dhcp` / `config dnsmasq`
    * `list addnhosts '/path/adhosts/hosts'`
* Set execute flags `chmod 777 ./adhosts.sh`
* Set [cron](https://wiki.openwrt.org/doc/howto/cron) and [startup (/etc/rc.local)](https://wiki.openwrt.org/doc/techref/process.boot) tasks:
    * `* * * */1 * sh /path/adhosts/adhosts.sh update`
    * `sh /path/adhosts/adhosts.sh start`

### Hosts files:
[StevenBlack/hosts](https://github.com/StevenBlack/hosts)
