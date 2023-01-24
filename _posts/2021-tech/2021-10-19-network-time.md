---
layout: mypost
title: NTP Network Time Protocol
categories: [tech]
---

NTP 工具用于通过网络同步计算机时钟，使用互联网上的公共服务器精确度可达 `1-50ms`, 使用局域网服务器精度可达 `0.1ms`.

配置文件：`/etc/ntp.conf` 
使用教程：https://www.thegeekstuff.com/2014/06/linux-ntp-server-client/

## Gists

- 一般 Ubuntu 默认开启了 NTP, 所以任意一台 Ubuntu 主机都可以用作同步服务器（如果没有防火墙）。如果需要，使用命令手动开启服务：`service ntpd start`.
- 与指定服务器同步：`ntpdate 192.168.1.1`.
- 如果需要设置自动同步，参照上文链接中的教程。
- 检查 NTP 服务状态 `ntpq -p`